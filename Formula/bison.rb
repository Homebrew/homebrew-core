class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.5.tar.xz"
  sha256 "e8c53bc5bc396d636622d0f25e31ca92fd53f00b09629f13ef540d564a6b31ab"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b0f383e37c2e1e4bb14b654b07e96e8da7a01bd19b4c41cd5d2d88198dabff90" => :big_sur
    sha256 "7717d17b5ebca46f673d4ba2eb5626c7a726c3e6203db10d0bf21185356841b6" => :arm64_big_sur
    sha256 "b4128068b3902c2f98a3a3d25d19ff63daf61449dfb21146d5b117a34b38a4ef" => :catalina
    sha256 "c9e6a12dd08f5a956d67e18294d49bc50803bc58decd4a0fb234e0606042e0fa" => :mojave
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
