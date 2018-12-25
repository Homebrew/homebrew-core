class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.4.tar.gz"
  sha256 "cb673e2298d34b5e46ba7df0641afa734da1457ce47de491863407a587eec79a"

  bottle do
    sha256 "cef69c115b08aa4e5322c5ec94809161fb0d7692b7bed17efb9d462ea03dbe2a" => :mojave
    sha256 "5db2e33394468af0e2b944289ea4f05a83bf14639c293215e0bae40a20e740a4" => :high_sierra
    sha256 "7c5c15c1a4936853995e2501216027c1f33739259a3cf02edadfbb7d5c117a15" => :sierra
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
