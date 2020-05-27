class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.6.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.6.2.tar.xz"
  sha256 "4a164b5cc971b896ce976bf4b624fab7279e0729cf983a5135df7e4df0970f6e"
  version_scheme 1

  bottle do
    sha256 "4633db79f9edfe468fb3f0fa77a2c40312ba728fc26f5cb4ae2b2b05a166caed" => :catalina
    sha256 "a4515e305a65872576b7ef88319fbc1e2d5f891b3797d95a8e04f74303fa8544" => :mojave
    sha256 "026b9386df09343cdc2103ca5844b57cf4adf6c17e76b7448dd02f919a7e7088" => :high_sierra
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
