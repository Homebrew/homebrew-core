class Lemon < Formula
  desc "LALR(1) parser generator like yacc or bison"
  homepage "https://www.hwaci.com/sw/lemon/"
  url "https://tx97.net/pub/distfiles/lemon-1.69.tar.bz2"
  mirror "https://mirror.amdmi3.ru/distfiles/lemon-1.69.tar.bz2"
  sha256 "bc7c1cae233b6af48f4b436ee900843106a15bdb1dc810bc463d8c6aad0dd916"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "286af27372fde1ea7ea8e0eb910a3707b622e73cfc1e66f23e7fbe4bf7d3d59c" => :catalina
    sha256 "99d4d1999862af18af2c16f3b80564e2202e3fbb17012283f0c9bdf87ef403b3" => :mojave
    sha256 "239bfe217ab89f4e6ef9fbfcc0f82996c3d5ab835324c3b91e42314e1cb002d3" => :high_sierra
  end

  def install
    pkgshare.install "lempar.c"

    # patch the parser generator to look for the 'lempar.c' template file where we've installed it
    inreplace "lemon.c", / = pathsearch\([^)]*\);/, " = \"#{pkgshare}/lempar.c\";"

    system ENV.cc, "-o", "lemon", "lemon.c"
    bin.install "lemon"
  end

  test do
    (testpath/"gram.y").write <<~EOS
      %token_type {int}
      %left PLUS.
      %include {
        #include <iostream>
        #include "example1.h"
      }
      %syntax_error {
        std::cout << "Syntax error!" << std::endl;
      }
      program ::= expr(A).   { std::cout << "Result=" << A << std::endl; }
      expr(A) ::= expr(B) PLUS  expr(C).   { A = B + C; }
      expr(A) ::= INTEGER(B). { A = B; }
    EOS

    system "#{bin}/lemon", "gram.y"
    assert_predicate testpath/"gram.c", :exist?
  end
end
