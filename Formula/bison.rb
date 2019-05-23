class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.4.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.4.1.tar.xz"
  sha256 "27159ac5ebf736dffd5636fd2cd625767c9e437de65baa63cb0de83570bd820d"

  bottle do
    sha256 "dc8227bb5e776441542d702321b0d3f063983c7d5aba0841e1919b7285f7caa1" => :mojave
    sha256 "36a473cc605a3b7bd7921609f6d41bda797d216f2e0c518acf1affc89ca493bd" => :high_sierra
    sha256 "7fa3a129f5ebd9200634941ba4c6f06558f0074283e33d193c6059318395808c" => :sierra
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
