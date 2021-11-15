class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.8.2.tar.xz"
  sha256 "9bba0214ccf7f1079c5d59210045227bcf619519840ebfa80cd3849cff5a5bf2"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78ce4e93936c37005e944b21e4b4d305725bc66f6c675acf2eb13cf72bac01cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb649b4e0b071ccfdce51193942366e894fb08be9798109eb718fb323369509e"
    sha256 cellar: :any_skip_relocation, monterey:       "feb2484898408e8fb2008f4c0ff39042bffb026ea4463d33fd0dfb5952895f1c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4fa1a0bf3245d8ef6a0d24d35df5222269174a02408784d870e4a882434712d"
    sha256 cellar: :any_skip_relocation, catalina:       "5a79db63b8a10bc6211ed6a9dcef6df91c26d9fe3420047c285960dede637ea5"
    sha256 cellar: :any_skip_relocation, mojave:         "4b51739abc4ac54df710147848eb0cd12ff32bc0b86b9112d0de378a74273328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d708c29c7e44f28a4fa77d353ff7adfbe673b31cef6f24c3c384a03ba01b3608"
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
