class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.2.0.tar.xz"
  sha256 "d4f3cd31c001fd0ed52832d4fbfbdfeaa38ad541c182f80ff8fdf87324a6a9f2"
  revision 1

  bottle do
    sha256 "8f594a72cd1f11264f1a5df92f0318ab4ef3fe1772ca157f1b8a27d2be79dd26" => :high_sierra
    sha256 "604603592f400a332898ec34e8e0efc4abd636b6983540f20b5d693531c64d8e" => :sierra
    sha256 "ddb688892a4ba768a8d0d21c6a643c6a0efe327e35f1a19b0064a42ab228b033" => :el_capitan
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
