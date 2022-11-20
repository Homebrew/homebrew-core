class Pike < Formula
  desc "Dynamic programming language"
  homepage "https://pike.lysator.liu.se/"
  url "https://pike.lysator.liu.se/pub/pike/latest-stable/Pike-v8.0.1738.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/p/pike8.0/pike8.0_8.0.1738.orig.tar.gz"
  # Homepage has an expired SSL cert as of 16/12/2020, so we add a Debian mirror
  sha256 "1033bc90621896ef6145df448b48fdfa342dbdf01b48fd9ae8acf64f6a31b92a"
  license any_of: ["GPL-2.0-only", "LGPL-2.1-only", "MPL-1.1"]
  revision 1

  livecheck do
    url "https://pike.lysator.liu.se/download/pub/pike/latest-stable/"
    regex(/href=.*?Pike[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "3ff13701ed6f1b07323df232c6fcd35125fea646fd0a78ec29c06a1bd3eab29c"
    sha256 arm64_monterey: "49738b5e4a0c626992a93f2ea98bca84ba1cd5c4a3f5bb1dec3aa76b8f7f9320"
    sha256 arm64_big_sur:  "966941419e0ad6d79afe1c06cbf5c6426987a4fb044118efaf639db74ecf9f74"
    sha256 ventura:        "1650ccd2417aa16e7a70b1677ff6524de9461c6e11d69aac0f17d3d8943a1bb2"
    sha256 monterey:       "67a354ed3a0cbc132c61fb3042b9f3dfbcaadad7f43fc43aaa70c4c60ac90838"
    sha256 big_sur:        "f7d73f5d026696f371a577db4e34a271b9f4844df9a5671a78f7e00f1373311b"
    sha256 catalina:       "fba4b09bca334abbbfb682151ca87e173d31250cf1f2682cb84f171c47d0723f"
    sha256 x86_64_linux:   "1681d64d3aa898314870cc8f2838ee7b56e87d41d431c655526c04424166891d"
  end

  depends_on "gettext"
  depends_on "gmp"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "nettle"
  depends_on "pcre"
  depends_on "webp"

  uses_from_macos "krb5"
  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "libnsl"
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
