class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.4.tar.xz"
  sha256 "4c17e99881978fa32c05933c5262457fa5b2b611668454f8dc2a695cd6b3720c"
  version_scheme 1

  bottle do
    sha256 "f3adb7cb317074ac939047be5dc1820d4aa5c857a334de2b2fcf9cf694dc25c2" => :catalina
    sha256 "6c13eb5c732e27919a7f1a247fe58481c1610c04565d5774ffbfc08d55cbefdc" => :mojave
    sha256 "6b8f5ff74c085518ee49d88336211bb2dcadd0c507f3e31ecb5fc2e24df506ff" => :high_sierra
  end

  keg_only :provided_by_macos

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
