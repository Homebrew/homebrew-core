class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.6.tar.xz"
  sha256 "67d68ce1e22192050525643fc0a7a22297576682bef6a5c51446903f5aeef3cf"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 arm64_big_sur: "05d792ec204c66eb1f38e4d4374df2534999546212e3e91a7b57e6d1a956c325"
    sha256 big_sur:       "2c1e18a4cc7a16cf2b2ec53a1a8a1946268b9e3dee188049790c462ba9490795"
    sha256 catalina:      "10aed89a3e041fea22157a87f37d46c1cdfba1e2b02ab6e6dbee995b033046ec"
    sha256 mojave:        "589567242c46e728e28818ea075044b8443f5c37e85e35a84da4b008aa3db237"
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=/output"
    system "make", "install", "DESTDIR=#{buildpath}"
    prefix.install Dir["#{buildpath}/output/*"]
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
