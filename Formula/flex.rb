class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "http://flex.sourceforge.net"
  url "https://github.com/westes/flex/releases/download/v2.6.2/flex-2.6.2.tar.gz"
  sha256 "9a01437a1155c799b7dc2508620564ef806ba66250c36bf5f9034b1c207cb2c9"

  bottle do
    rebuild 1
    sha256 "ef2445631f180459f022f25e199a1d1ef3aff14adf597ff089c86d15c19adc45" => :sierra
    sha256 "b9f97a19146f3086b4084e83c91c30329b3536fc3032687de724f8408c2e2e3b" => :el_capitan
    sha256 "36715dd9edb6e16caf33e1d5e6b87447da1bd40fb49325e18d7269bc162bad81" => :yosemite
    sha256 "0a322eea192fb9b68e869d180c9c7c0ec099d72c574505c8af1ba5485a601e95" => :mavericks
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
