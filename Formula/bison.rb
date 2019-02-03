class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.3.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.3.2.tar.xz"
  sha256 "039ee45b61d95e5003e7e8376f9080001b4066ff357bde271b7faace53b9d804"

  bottle do
    sha256 "87b6e223b39d74fcc9139bc910b57c9bf3907cdea08b46fe76adf056fa7fa71b" => :mojave
    sha256 "c84c62b3e93d4f247da3d9b96576a20039049a715d061c485e2b6648d66802d5" => :high_sierra
    sha256 "9aea608a387b58fa8182215e0df651346e3246830acdc3d731a32b8775184d81" => :sierra
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
