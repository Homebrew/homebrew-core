class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.2.tar.xz"
  sha256 "24e273db9eb6da8bbb6f0648284d0724a5cbd6268a163db402f961350a4e50dd"

  bottle do
    sha256 "7dcd7937e3dab093aad91ba6b3cf08957186b8e84b70dfe9b11ae4f2646e4af1" => :catalina
    sha256 "8801d5a600bdb9258bf406927e6dca12052246e590cf69a8915459f42a87453b" => :mojave
    sha256 "5725e8e9d8a50edf3d985fa2a77236985cb7a84a34f1b9230b4d917b2ed0f35d" => :high_sierra
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
