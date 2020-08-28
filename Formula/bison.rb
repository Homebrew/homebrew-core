class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.1.tar.xz"
  sha256 "55c215521a13982a9bee68cd42eed51a65713f96c530a739a57de4438ac1bb69"
  license "GPL-3.0"
  version_scheme 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "994ac8fcc6e0c291e3a512dc98ad2549aa7a79f13e4c114ea28d48221ec3d925" => :catalina
    sha256 "9a608f52daa7af288363bf07e5085d8403481fe9a8a516730c51f51a7bc08748" => :mojave
    sha256 "18ea63379fe5a4fb03c375d8bdc5bfaa9825bf0fcb9e4ab8c77117bb6543be08" => :high_sierra
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
