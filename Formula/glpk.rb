class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-5.0.tar.gz"
  sha256 "4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c6f0f13896167f69d3dc9fed18ea36e19745006516abbff71d4dbf1a1a0c569b"
    sha256 cellar: :any,                 arm64_big_sur:  "e05ebe154868c3ae41e25c6d2bff72596275dc93c74a4f6f1a88c15a553a9bf2"
    sha256 cellar: :any,                 monterey:       "7eddbd4943eb50123bdfcd539d38932297e56ff61ae66dcb2ec633f60982f6c1"
    sha256 cellar: :any,                 big_sur:        "3f577566f72aa88262e78c5df12974f25f76ebca6632f8e9ccecf7b5ff222d2b"
    sha256 cellar: :any,                 catalina:       "dd6461053c93e0fc37577251f83a17de325efe8382805f5bc883c8a3a018e74b"
    sha256 cellar: :any,                 mojave:         "2fbd223a7089b352aa9a6e424660aec34edbcaa8fbac7665fe7a9cab2b3f7aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2917fa8ab16e56c8f786514f5334598dcc81a939aa7c6c13be41c21d4e1b283"
  end

  depends_on "gmp"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

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
    assert_match "OPTIMAL LP SOLUTION FOUND", shell_output("./test")
  end
end
