class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.8.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.8.1.tar.xz"
  sha256 "31fc602488aad6bdecf0ccc556e0fc72fc57cdc595cf92398f020e0cf4980f15"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f26eabffa4dd6d453b7c01e0491910bf70af70e400e1d684d3e31a511a7bfcf1"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3a25f8afa584abf7688824ad8eaa624b4702aa531339599c63947b2234c8dc5"
    sha256 cellar: :any_skip_relocation, catalina:      "7698f085a806dd977569237a92661673233232acc29803087eb4a8784cc621d8"
    sha256 cellar: :any_skip_relocation, mojave:        "80ea46ebdade5d5e8c8dbf6ea0c1e275ae669531b18bb06211b1c47bd27f0c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a09ac7dc0fce1ee99508401a60528bf1a9b515283577564af64f8ce4d91407b7"
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--enable-relocatable",
                          "--prefix=/output",
                          "M4=m4"
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
