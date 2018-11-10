class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.1.tar.gz"
  sha256 "01f33704298077dd39f3855ea2045bfc87f360395f52d6f4406b32fa3fdfecdd"

  bottle do
    sha256 "a5513ebde48dd4a88239b7645aa9da70c2275d622790edf1ce4cfbd04321e7ce" => :mojave
    sha256 "b28a1d436ba721ac21a18a78b58bc5e24fa7741ad879cde4a33f849773d03a35" => :high_sierra
    sha256 "5718deca6a4f62302ec970d4964935f99f34f058cceae571c552bcf44c9f47e6" => :sierra
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
