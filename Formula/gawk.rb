class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-4.1.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-4.1.4.tar.xz"
  sha256 "53e184e2d0f90def9207860531802456322be091c7b48f23fdc79cda65adc266"
  revision 1

  bottle do
    sha256 "370e7a490801595a484c347da99d8b6dce58d63f8581962cd6d16552e5a4992f" => :sierra
    sha256 "71d2f6ec3359647298cc0867b88653078ba933b09b139dcd00d76fe763ccb1bb" => :el_capitan
    sha256 "bc8bd37d3761403f22bf3937097c67d8e76e914c90abfa577fd7e17af337057a" => :yosemite
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
