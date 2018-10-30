class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.tar.gz"
  sha256 "d1a42d81cd708fedf943d4d8b2f9d22871526ba0d781563231045fc6edb2617d"

  bottle do
    sha256 "fa0524d2ce9d270a754bec391da539b04130934af50196bbd56c6363a25a7922" => :mojave
    sha256 "640477dd11d7e6a481b096607867b103bf2d929af21e5aa4b1e9258360cbea64" => :high_sierra
    sha256 "80da8c6f0bbb8dfcf6d823a8e5bb58135cb2246e1c6856993b0f65435ee130d0" => :sierra
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
