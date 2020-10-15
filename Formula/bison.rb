class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.7.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.7.3.tar.xz"
  sha256 "88d9e36856b004c0887a12ba00ea3c47db388519629483dd8c3fce9694d4da6f"
  license "GPL-3.0-or-later"
  version_scheme 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "f5bfd5e40ae8b0501e398e2ea29f95e8b80bdbabab2daedcb40c19cf5c4e3491" => :catalina
    sha256 "8a99fb499af4af8e49d93e8eae8b48e26a4c30400a9d7cc66e70ea0621b47e7e" => :mojave
    sha256 "20c775058c2bc15b2f7ccf27cf3b2817a98ea13cf656fa69f1877af2ea62cf04" => :high_sierra
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
