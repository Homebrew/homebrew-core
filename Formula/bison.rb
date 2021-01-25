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
    sha256 "b7a25d5b1a69dd214d31304edb008d378b9de7dfd026d04b2843786c9af88118" => :big_sur
    sha256 "733377e1e13ad873eae32d91d830975fa52e8d75514b042a7be38b3ec03d09be" => :arm64_big_sur
    sha256 "6252edf4d591cf1de3e94e9e08c5986205593da971d0b381a411d272c95cf30f" => :catalina
    sha256 "50a80771867419e621404f94ff89cab629fd1aff69bdb68a473fd41a233d00a2" => :mojave
    sha256 "b0015c5773c569e7de673bc2159f0c86d50422bc4fcf06de66f6bac1fe1f06c5" => :high_sierra
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
