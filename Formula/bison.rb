class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.3.tar.xz"
  sha256 "2bf85b5f88a5f2fa8069aed2a2dfc3a9f8d15a97e59c713e3906e5fdd982a7c4"

  bottle do
    sha256 "49c0e3d96af6a8c2f3538562072403da20dc02ac37de15c8e6d3f9e7187f8531" => :catalina
    sha256 "8d2a20738ce82a9d0595c4f5e46aecd1d2f9ec60272cc2855dcd621d53a3d37b" => :mojave
    sha256 "6436fa9c72eff64861db37b30c06aea16db665eb6a845c603b98660086123595" => :high_sierra
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
