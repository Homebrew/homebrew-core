class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.0.5.tar.gz"
  sha256 "cd399d2bee33afa712bac4b1f4434e20379e9b4099bce47189e09a7675a2d566"

  bottle do
    sha256 "05b65293f4429cafef03ec3011e0edf90c4b3399fd6c917fe6e21a649c96ef66" => :high_sierra
    sha256 "06481bf85b252a3b362523d67b10b0e910cf353dccec93b28fb6e62e2bf0cd8b" => :sierra
    sha256 "19c9c94ff3e215c60be1d4c85ee2f385528760cbf9b1348f62e21e7dfb5f49cc" => :el_capitan
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
