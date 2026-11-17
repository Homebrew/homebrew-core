class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.16/flex-2.6.16.tar.gz"
  sha256 "c778edc11a53b86aa33203f51d179cc294e5a5d07f84285eaa34c76c3f902bab"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3f14b4daf21270500ff9a05eb78c6d4e71301f01a68ab73e4f3c9f0d6baa5e2b"
    sha256 cellar: :any, arm64_tahoe:       "6eac9493cabd5e147461322974af5ff9af8467fe1f68a01e3f499e668cd8ac75"
    sha256 cellar: :any, arm64_sequoia:     "c624bf38b3478f43306decf4db2071254972c3ae93b9b576c61a268982c31a5b"
    sha256               arm64_linux:       "5b79752ec108ab1f65358785a3f9051fb2f1efbe751eb19b480131c7847bc1a2"
    sha256               x86_64_linux:      "ae9a77a7bd1894e8d14d5e870af7cfb8d35c57038c0d3dfc55cad018548c22f3"
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
