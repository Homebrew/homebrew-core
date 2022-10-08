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
    sha256 arm64_monterey: "c4e37ca2994a9ba373c02a02517fcc48bc519a9a8a0e5c57e402380a208b0b9d"
    sha256 arm64_big_sur:  "ba08b3b50818a356a82d795f38b689cba16493c97adf778f1fc138307b5c7eda"
    sha256 monterey:       "fcbcae19d940140648fa7325ff71e57ab1fc1f928d70b7478e2febe8ba4fda2b"
    sha256 big_sur:        "2fbf0d3dbef364f3b48c4d560814799ce04fcb1eed4b4fdf2ffcdffb263fcece"
    sha256 catalina:       "8e89a5064e6ea44933c277ee883cfe7b8c2ee7c0f97db022b00d1ee24f173e4f"
    sha256 x86_64_linux:   "57379ff0971a0c74960edf4db1d3b8ea2e0b552bd5e6aae431fee24078cc9c90"
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
