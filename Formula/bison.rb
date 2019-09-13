class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.4.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.4.2.tar.xz"
  sha256 "27d05534699735dc69e86add5b808d6cb35900ad3fd63fa82e3eb644336abfa0"

  bottle do
    sha256 "96565e8ced7e49173e86a6971a71a205814411945d86d599733ab83b2e24afad" => :mojave
    sha256 "f3d31e53aab90da30dc83e3c9cc5a8f6821e501acb341d2e6cf8ae39e357ec7c" => :high_sierra
    sha256 "606a6ec0b5fa0adaa07ba8cdcb2c99e40d3b6c9a690d324f1688e5a832c2452b" => :sierra
  end

  uses_from_macos "m4"

  keg_only :provided_by_macos, "some formulae require a newer version of bison"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
