class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.2.4.tar.gz"
  sha256 "cb673e2298d34b5e46ba7df0641afa734da1457ce47de491863407a587eec79a"

  bottle do
    sha256 "41dc4a7c7d51d7579cccd1875cd3f683dbbdb07db47ea10d07e61d7502ebc380" => :mojave
    sha256 "66e597575145349e5acaf9ff8b1a08a8582dc0ea3e2ec80c00a99ab2b6aa9aca" => :high_sierra
    sha256 "f74574ab0ec6c7c6c5a143b0b46303752482be1d37b36c7b74c534fa7499e446" => :sierra
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
