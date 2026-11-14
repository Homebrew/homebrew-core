class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.13/flex-2.6.13.tar.gz"
  sha256 "a54de3a79dc191d9d9a3acd07b8981be160d1be588261ef7687ccfdaeb1190ed"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "085672f3ba27712c07f3f3ffc052851aeafc84a3fa8e6f03eed08d430c5bbede"
    sha256 cellar: :any, arm64_tahoe:       "27b7607c2c4d1937597edc721a40a9d5dc2e34300d875368b99e79735e3246a1"
    sha256 cellar: :any, arm64_sequoia:     "1e8acded2a56d49196ce6838bcb9425747e4a4d5dc40feea6e14bd8af7a40270"
    sha256               arm64_linux:       "a7dbe9f31bc5053d61a64df95d209e5fd1074aabf8affa25672c644934e82c67"
    sha256               x86_64_linux:      "25b28ea80fb1fc479ec250cf93e4d0be499f39cfaa901fcbbcd17a6d7d3ff5a3"
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
