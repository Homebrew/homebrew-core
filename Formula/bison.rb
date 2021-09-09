class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.8.tar.xz"
  sha256 "1e0a14a8bf52d878e500c33d291026b9ebe969c27b3998d4b4285ab6dbce4527"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee20f2693b08afe6bf50abad5e9a6adf60b629360c64fb580f0512283d87846f"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f57b6c53d6595330adf79112e72034895f061769ebc8906a9b5afe9f4f873d0"
    sha256 cellar: :any_skip_relocation, catalina:      "2276ffa48c694379540f63a5241c39b738f1dcb7424aceec54beb2e7be172489"
    sha256 cellar: :any_skip_relocation, mojave:        "0dca09521f16b6e49e2c21ae9dec6069fee065a9ffd4b8191dca66b1957937d6"
    sha256                               x86_64_linux:  "eb96cc1d339ce9801401788533de08223557811d3066622fa6d56d9e59b2eb86"
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
