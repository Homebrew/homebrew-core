class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.6.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.6.3.tar.xz"
  sha256 "06db793651de9dd5f0a85a6fe4bdbca413c0806bf2432377523da96ca0b4b73d"
  version_scheme 1

  bottle do
    sha256 "f62ace95d7fe27ed4acf22ea11131aceba751df349bcac8f4a217f9e8e378c78" => :catalina
    sha256 "bedd3320b06a67e2627c15973362acff117aabec64660b7a948ce8b68023ff1e" => :mojave
    sha256 "6d54d8a9e22f110ee823fca7dc105d09f5a84878b9cb0c492ba9f6bd26e974a8" => :high_sierra
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
