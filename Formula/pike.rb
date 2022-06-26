class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1738.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1738.orig.tar.gz"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  sha256 "1033bc90621896ef6145df448b48fdfa342dbdf01b48fd9ae8acf64f6a31b92a"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ffc4be44537cbfdee288908954eba9770285f1125605d1572ae07cc5cb957e74"
    sha256 arm64_big_sur:  "f0b5027d1b973ae8032a248b61a947a0310c0aad40d973cfa55ed0f0f21444cf"
    sha256 monterey:       "c8a4f96f3d11502a5b8f86cc50c2fcad1785bb5319989b7812b3bd9354a7a7ac"
    sha256 big_sur:        "ba630c7d573cb8079a2493a22ee092061ea7c041ceb61c7c2264fd23ebb7de97"
    sha256 catalina:       "ac8c57905aaa692ecd95f716a4e5daab9d7b030470cefd99a3b2043ceb19e5de"
    sha256 x86_64_linux:   "d1b09df6210744180a51992d93ba0d4344fea5fff256b6434486f909f0457a94"
  end

  depends_on "gmp"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "jpeg"
  end

  def install
    ENV.append "CFLAGS", "-m64"
    ENV.deparallelize

    # Workaround for https://git.lysator.liu.se/pikelang/pike/-/issues/10058
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    # Use GNU sed on macOS to avoid this build failure:
    # sed: RE error: illegal byte sequence
    # Reported upstream here: https://git.lysator.liu.se/pikelang/pike/-/issues/10082.
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

    system "make", "CONFIGUREARGS='--prefix=#{prefix} --without-bundles --with-abi=64'"

    system "make", "install",
                   "prefix=#{libexec}",
                   "exec_prefix=#{libexec}",
                   "share_prefix=#{libexec}/share",
                   "lib_prefix=#{libexec}/lib",
                   "man_prefix=#{libexec}/man",
                   "include_path=#{libexec}/include",
                   "INSTALLARGS=--traditional"

    bin.install_symlink "#{libexec}/bin/pike"
    share.install_symlink "#{libexec}/share/man"
  end

  test do
    path = testpath/"test.pike"
    path.write <<~EOS
      int main() {
        for (int i=0; i<10; i++) { write("%d", i); }
        return 0;
      }
    EOS

    assert_equal "0123456789", shell_output("#{bin}/pike #{path}").strip
  end
end
