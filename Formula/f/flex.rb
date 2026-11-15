class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.14/flex-2.6.14.tar.gz"
  sha256 "3a5743b2cf171ab61843aed70b836a0a33a3fa70dd04f758f3a2b6a78e774680"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3adcf2e7133a8394682d769b5b869098ddb0f5005f030b699efa64704eb3d5a5"
    sha256 cellar: :any, arm64_tahoe:       "1aabb2118f1c81e7e8f644c50597eb3d53977521829a42a28318e55bb58e1c37"
    sha256 cellar: :any, arm64_sequoia:     "95ccb6fec1a5cf3398209f8d2a89f635e72eb5bd861f6077094471aaab2bff85"
    sha256               arm64_linux:       "ff555b807a02bc14b527fe817e3d8aedc96465b5e97687eedb85d419f2fdc01c"
    sha256               x86_64_linux:      "98341602d0aae24b29bea229515b372c051ddc404df1eb98cea062b8f8d7fd73"
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
