class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
  sha256 "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"
  revision 1

  bottle do
    sha256 "902e2701bb4d8130fe3177211dda84b6ebc6a520467874a52bcd7ff043b949cc" => :catalina
    sha256 "2051ed8f0de322732b111f2cc82069e82f6dfd4d839e6d098bbebcd7f92220e6" => :mojave
    sha256 "9c224c27a3d40a53b6f778a6b825f8b4f14654080b144e50f1bec9cc608c757d" => :high_sierra
    sha256 "a958106ee0895b21c7577478b847ecdbc601ce6a723543c5da455bfe0eee5f8f" => :sierra
  end

  head do
    url "https://github.com/westes/flex.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    # https://github.com/westes/flex/issues/294
    depends_on "gnu-sed" => :build

    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos, "some formulae require a newer version of flex"

  depends_on "help2man" => :build
  depends_on "gettext"

  def install
    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.flex").write <<~EOS
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
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<~EOS
      Hello
      World
    EOS
  end
end
