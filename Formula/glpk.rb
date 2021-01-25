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
    sha256 "3f577566f72aa88262e78c5df12974f25f76ebca6632f8e9ccecf7b5ff222d2b" => :big_sur
    sha256 "e05ebe154868c3ae41e25c6d2bff72596275dc93c74a4f6f1a88c15a553a9bf2" => :arm64_big_sur
    sha256 "dd6461053c93e0fc37577251f83a17de325efe8382805f5bc883c8a3a018e74b" => :catalina
    sha256 "2fbd223a7089b352aa9a6e424660aec34edbcaa8fbac7665fe7a9cab2b3f7aac" => :mojave
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
