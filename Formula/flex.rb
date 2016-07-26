class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.xz"
  sha256 "2c7a412c1640e094cb058d9b2fe39d450186e09574bebb7aa28f783e3799103f"

  bottle do
    sha256 "05b6edc15c30f5ec903a45e08de56e9e2750fe3e2fa172157ff046b078980ad5" => :el_capitan
    sha256 "b8e264ed3b801e267d32722b156ba581f087ea9c9db6c09fb420220862669481" => :yosemite
    sha256 "ef0c36af7a14abf0386ec9ec36150857f69b7fd6ffcccafaa4f40ddd157cc35c" => :mavericks
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-shared",
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
