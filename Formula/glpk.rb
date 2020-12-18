class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-5.0.tar.gz"
  sha256 "4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "cf853007ad66b4670d9226f44080c43b8b0c24e21be4fb185b0e7b97994d6a76" => :big_sur
    sha256 "55bd72ce9a73c652c34616d09d8ca7d05028c089835c9f0e91db0868e626fc05" => :catalina
    sha256 "563546e59d89de41270630d03276672f927037c28d6c64531791524cb7e611e4" => :mojave
    sha256 "5c0b4a34749c6e60bf9aa39f175ca907bab774f89a1b8a1697f3f5d02d493f2a" => :high_sierra
    sha256 "3cbe0b40e3852414560a4929da0ee050fc8fa424b56b3ea756f853ce274b9a3a" => :sierra
    sha256 "90ba265eb683981e612faae96318b662558e828a99a89200a29df93006d34084" => :el_capitan
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp"
    system "make", "install"

    # Sanitise references to Homebrew shims
    rm "examples/Makefile"
    rm "examples/glpsol"

    # Install the examples so we can easily write a meaningful test
    pkgshare.install "examples"
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

    system ENV.cc, pkgshare/"examples/sample.c",
                   "-L#{lib}", "-I#{include}",
                   "-lglpk", "-o", "test"
    assert_match /OPTIMAL LP SOLUTION FOUND/, shell_output("./test")
  end
end
