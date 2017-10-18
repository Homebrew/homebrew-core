class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-4.63.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-4.63.tar.gz"
  sha256 "914d27f1a51c2bf4a51f1bd4a507f875fcca99db7b219380b836a25b29b3e7f6"

  bottle do
    cellar :any
    sha256 "cf81b5c532d726bb08ae3ebb5c22e7ad763334ecc586b4ec7eafeba49b9a8dc4" => :high_sierra
    sha256 "c5491836b25e7fe78f37d56b72406f9dabf9caeec8ea97e1b4b0356ab228fd6c" => :sierra
    sha256 "af604b5830e07dafadc57b26b84c352d6de62904dfb2587dcdc6a201601d8cda" => :el_capitan
    sha256 "ea544cd7cc6b81e513909ac35825cd4b67ae5d7500d2553dad3eb679939d7f71" => :yosemite
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "glpk.h"

      int main(int argc, const char *argv[])
      {
        printf("%s", glp_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lglpk", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
