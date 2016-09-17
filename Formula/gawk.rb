class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gawk/gawk-4.1.4.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-4.1.4.tar.xz"
  sha256 "53e184e2d0f90def9207860531802456322be091c7b48f23fdc79cda65adc266"
  revision 1

  bottle do
    sha256 "6525b7d9b5bb4f828971ecf9f229c7eb7e978fa4b296c69a8877b23954050ffb" => :sierra
    sha256 "02651beb7f8ac06f197e69f8508fb97c90c82980172d35da023c5d34fb9b0ff6" => :el_capitan
    sha256 "2ef527c9f399a504de1c72706dc0123c47d8ce91892840346928a739d81cd93f" => :yosemite
    sha256 "73bf29a5c50d0a9a2062f7d80a24c0a097f74f9fd8c139b26e4c1f8004e33603" => :mavericks
  end

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  depends_on "mpfr"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
