class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://github.com/westes/flex/releases/download/v2.6.1/flex-2.6.1.tar.xz"
  sha256 "2c7a412c1640e094cb058d9b2fe39d450186e09574bebb7aa28f783e3799103f"

  bottle do
    sha256 "5ff47ed93df4c58a708c88d5638180dc989e17f1ac0ef2caf13bba20d32e646a" => :el_capitan
    sha256 "a66259c848d0afb9b825b8f3cf9a303c33e815d5ba419a1c5401342d1ff43a9f" => :yosemite
    sha256 "b2aeeaaa2b4de481c5b4fad5e3250b5e3e878bb7dd321b5234575d2b184a86be" => :mavericks
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
