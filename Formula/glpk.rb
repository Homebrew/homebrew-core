class Glpk < Formula
  desc "Library for Linear and Mixed-Integer Programming"
  homepage "https://www.gnu.org/software/glpk/"
  url "https://ftp.gnu.org/gnu/glpk/glpk-4.63.tar.gz"
  mirror "https://ftpmirror.gnu.org/glpk/glpk-4.63.tar.gz"
  sha256 "914d27f1a51c2bf4a51f1bd4a507f875fcca99db7b219380b836a25b29b3e7f6"

  bottle do
    cellar :any
    sha256 "eb9e4fe20ad44eedc7e084493045fabeb6b4341f7c65c77ee7f338065d3bc2df" => :sierra
    sha256 "619f16ce7a6a0060171a9ad18fd60eb0d106628de1a5854a6a1851a189a60b71" => :el_capitan
    sha256 "a092c4d68cbf2625e6fbcda6a24201fd6fb820f44861005770ed0593f7c41f6f" => :yosemite
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--with-gmp"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOF.undent
      #include <stdio.h>
      #include "glpk.h"

      int main(int argc, const char *argv[])
      {
        printf("%s", glp_version());
        return 0;
      }
    EOF
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lglpk", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
