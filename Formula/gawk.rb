class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftpmirror.gnu.org/gawk/gawk-4.1.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gawk/gawk-4.1.3.tar.xz"
  sha256 "e3cf55e91e31ea2845f8338bedd91e40671fc30e4d82ea147d220e687abda625"
  revision 1

  bottle do
    sha256 "008ea93aab404959ba414514fc77aaecf627aee2f6d70ccdfd5281dee60d73a8" => :el_capitan
    sha256 "2bee2d5abfdbff06063bf07fb314ce3313d0b1eb797cfe921e08dc56e72a7e7f" => :yosemite
    sha256 "a6e562c18ebb1c9f82df368ca14ff720869956784f304e7a548be9e28343cc3c" => :mavericks
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
