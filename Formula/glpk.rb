class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-4.65.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-4.65.tar.gz"
  sha256 "4281e29b628864dfe48d393a7bedd781e5b475387c20d8b0158f329994721a10"

  bottle do
    cellar :any
    sha256 "0edf15d46002b9c704114574f134755b711fcc334478c7858ca5c1a7825cf22e" => :high_sierra
    sha256 "01862dd45d86c83f65c57a8b3e8e26dc8ce9dc865a6d5606db7f560792c0ecbe" => :sierra
    sha256 "e9e737b3c9dbeb639f1e6dd7d43fad8589d4df9a1407b6448c8f56ddbe0eded8" => :el_capitan
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
