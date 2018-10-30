class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.tar.gz"
  sha256 "d1a42d81cd708fedf943d4d8b2f9d22871526ba0d781563231045fc6edb2617d"

  bottle do
    sha256 "d12f195dfc10e7ddbe3ad79e646f43da607d1b57068b6c728e01c2029445743b" => :mojave
    sha256 "07aeea960757c9db4633f532ffa57b526a8c0ade186caae63d985474e68e643f" => :high_sierra
    sha256 "0deeabe5fe3de5d81b5940bb9f2c6a457dd6eac0a10d518c1483f618a6bef19e" => :sierra
    sha256 "99c319dc82e2a823f9c16a3909931e0970dc5cd189badb224c57a5786eb44016" => :el_capitan
  end

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
