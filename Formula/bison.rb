class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.4.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.4.2.tar.xz"
  sha256 "27d05534699735dc69e86add5b808d6cb35900ad3fd63fa82e3eb644336abfa0"

  bottle do
    sha256 "0908297a5806ee2bfd3ce20e88ca83cb43252f937b0edfb206cc4c3aa6fc1212" => :mojave
    sha256 "30f01dbe68208544cf61eb26895facc6c3ffd788a97097286261ebfab4736112" => :high_sierra
    sha256 "38fb4e95438e8d7ecd176c047880822bba5c6c6ce352516fce161fa6ba36bce8" => :sierra
  end

  uses_from_macos "m4"

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
