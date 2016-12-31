class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://github.com/westes/flex/releases/download/v2.6.3/flex-2.6.3.tar.gz"
  sha256 "68b2742233e747c462f781462a2a1e299dc6207401dac8f0bbb316f48565c2aa"

  bottle do
    sha256 "c7bcd12da4584e7d59e3801f92711820f2b9223d686326693a42da7733cd408d" => :sierra
    sha256 "b9f443e7292fe613dca088f7c4d26bf636086bee799c0dda06d8371b6702b410" => :el_capitan
    sha256 "637020dcd2cb5895b9da6c248e6035a3cbb91e3a310b7e71cb5f9c4ae959f149" => :yosemite
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "help2man" => :build
  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.flex").write <<-EOS.undent
      CHAR   [a-z][A-Z]
      %%
      {CHAR}+      printf("%s", yytext);
      [ \\t\\n]+   printf("\\n");
      %%
      int main()
      {
        yyin = stdin;
        yylex();
      }
    EOS
    system "#{bin}/flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<-EOS.undent
      Hello
      World
    EOS
  end
end
