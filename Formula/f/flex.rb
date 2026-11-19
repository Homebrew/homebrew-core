class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.2/flex-2.7.2.tar.gz"
  sha256 "365b86feb4a63f9a1743b789f360a796d82fe7344eae7facc95e065c84d8e284"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ca43ab5432b30c96664cab748e8ae5be0ae034ab048d88c92249a2e4f7e0dd14"
    sha256 cellar: :any, arm64_tahoe:       "45b76e4f189a7ece4c21b69ec2a1726790ad30d005ccdfd629ceb0a4d868bb23"
    sha256 cellar: :any, arm64_sequoia:     "9a6d8146c6b6e355126cf172cf91172ad2b95436c0d869813f10fb5ca588594d"
    sha256               arm64_linux:       "865ecfc40ceb10a25ac9944a3f3090de088a94c672de530a73c57ad9e61946de"
    sha256               x86_64_linux:      "8784753d1eaf57a1391ee3ec7713f32079e24122ed730d18a4285231109dcd45"
  end

  head do
    url "https://github.com/westes/flex.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build

    # https://github.com/westes/flex/issues/294
    depends_on "gnu-sed" => :build

    depends_on "libtool" => :build
    depends_on :macos # Needs a pre-existing `flex` to bootstrap.
  end

  keg_only :provided_by_macos

  depends_on "help2man" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "m4"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    if build.head?
      ENV.prepend_path "PATH", formula_opt_libexec("gnu-sed")/"gnubin"

      system "./autogen.sh"
    end

    # Fix segmentation fault during install on Ubuntu 18.04 (caused by glibc 2.26+),
    # remove with the next release
    ENV.append "CPPFLAGS", "-D_GNU_SOURCE" if OS.linux?

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-shared"
    system "make", "install"
    bin.install_symlink "flex" => "lex"
  end

  test do
    (testpath/"test.flex").write <<~FLEX
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
    FLEX
    system bin/"flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal <<~EOS, pipe_output("./test", "Hello World\n")
      Hello
      World
    EOS
  end
end
