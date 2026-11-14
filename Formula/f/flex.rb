class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.12/flex-2.6.12.tar.gz"
  sha256 "98ad69ecdf7c9c1100d34110ebb5d8cdbacc482d6968ed3c49d6a62e5372c6ff"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fa02606fe8873fd98d3a07b7537aea05b5165b00fb7a1c2bf1f958f158e14eb0"
    sha256 cellar: :any, arm64_tahoe:       "d216e586e1091d1ccfa06a9496f6cf5c8a34e00b697d569cf58381cf6b1ff4b5"
    sha256 cellar: :any, arm64_sequoia:     "d2b14d572cb51f92e26e915d08663d7be0e62d3067dce5d4dcbc17aea6b54d82"
    sha256               arm64_linux:       "d95efae350e339945dc00b3f520612299a3f1cf71e7b67fac0e17e70eda8df2d"
    sha256               x86_64_linux:      "536a0c363e76c8a7a27211c15561b95ee8372deb0ecd4899ccad44410905050b"
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
