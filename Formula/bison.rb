class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.0.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.0.5.tar.gz"
  sha256 "cd399d2bee33afa712bac4b1f4434e20379e9b4099bce47189e09a7675a2d566"

  bottle do
    sha256 "5701d6ce4222aac2a510772d6755777bb6162599c5c9169e11781f08fbcebca2" => :high_sierra
    sha256 "790d7ebb2aba8bc5db4efcc19e6e8c89bdf39163ec20168b9f238807b4dc7fa3" => :sierra
    sha256 "ad8ea27a2a19efa903bbd094bffdc5f80e5e5fc641a31c3649a3a23110b5d455" => :el_capitan
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
