class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
  sha256 "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"

  bottle do
    sha256 "89fb9ae2ac9be0f60706f40379cdfa51ced78f1638ac8729bc0074e4fcde70cf" => :sierra
    sha256 "95c2da56e5487b53ee4afe3ed52a7f59ffe86df4508768b3e48ef042d66e6cc1" => :el_capitan
    sha256 "c8aaca29a77a6b3e2383f7d80b12eccbbf131162e5157a4a320117d4c564a4bf" => :yosemite
  end

  keg_only :provided_by_osx, "some formulae require a newer version of flex"

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
