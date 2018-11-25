class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.2.tar.gz"
  sha256 "3ffd2201041c6c56064b4bdad4dfb8959751efbefa823775242b4f32aa37786c"

  bottle do
    sha256 "26e06cc3df3a85706ed99e75c4e8e404cf8e69977c3b749cd24286c3e023feae" => :mojave
    sha256 "6ca37bd5539ec8420d047e31ac5cdf48b441ed97b3862f03b32808d1bb96ebdb" => :high_sierra
    sha256 "efb28bf1d0514aa17efce0effa2fb082da4384a2bd87f0f4f6c5b17746e2ebd0" => :sierra
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
