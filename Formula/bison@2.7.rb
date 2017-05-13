class BisonAT27 < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-2.7.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-2.7.1.tar.gz"
  sha256 "08e2296b024bab8ea36f3bb3b91d071165b22afda39a17ffc8ff53ade2883431"

  bottle do
    sha256 "f826962030514764d143e70416b82ad39b83b011f56836ed66dde769d267f1c5" => :sierra
    sha256 "f445b3e75cf7ac40ef2b4bfa2953acaf477e21bc9fae7957584772a49b54872a" => :el_capitan
    sha256 "bafa9e03f97e3de2199a7c612d86f15dbb9722f77865a35a6d1cffb2d501841a" => :yosemite
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<-EOS.undent
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
