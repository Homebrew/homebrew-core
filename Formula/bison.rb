class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.6.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.6.4.tar.xz"
  sha256 "8b13473b31ca7fcf65e5e8a74224368ffd5df19275602a9c9567ba393f18577d"
  license "GPL-3.0"
  version_scheme 1

  bottle do
    sha256 "fa08dd0a1dba7bfa9ed18da2ffb499ebcc937e6cbc5a1f6acef3d21100809488" => :catalina
    sha256 "63bf0bf94d33d9c54626574815748ad614ebe8e9bdcf157a4053c98fcecde837" => :mojave
    sha256 "6d3c4120535bafcb81ef4539d6cf7422a03a158192bf2c2555e52850673e8047" => :high_sierra
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
