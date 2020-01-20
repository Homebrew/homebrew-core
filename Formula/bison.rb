class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.1.tar.xz"
  sha256 "3e7e097bd9709a2d5e40e69446b74b149733b3de864fadb7a9b54eca7b2a4dd0"

  bottle do
    sha256 "0a99cc32f88221f5e733ee7db13536f83a2e5232458f89b1725a3bfe09013b08" => :catalina
    sha256 "9e0c9fffc249e3578f103b70163e76cb6757c896794e7c59c5caf17c7ff32258" => :mojave
    sha256 "ef24c90f7fb895768f1c96b9822dae1b112b068a075e2afd5baf398313b6d395" => :high_sierra
  end

  keg_only :provided_by_macos, "some formulae require a newer version of bison"

  uses_from_macos "m4"

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
