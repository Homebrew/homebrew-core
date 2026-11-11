class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.6/flex-2.6.6.tar.gz"
  sha256 "f7b9c337d570c96c7e905e06cd15420c339856eead4335c51cfaf6a5c59189fa"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "77ca4ce5c797bb7e60d0109d8ddbd8a0dd1f3f5fb26aa57068d2882db9a3ec64"
    sha256 cellar: :any, arm64_tahoe:       "82543c856fbd1bf36e5d3fee15f25adea1819407cfe01339123f83ce37b95af1"
    sha256 cellar: :any, arm64_sequoia:     "b98fa0c84461a55ece1613918efff24718246e644c84f0c5e1e9e8e8b6f034fb"
    sha256               arm64_linux:       "61704945588e0b15bf6259657e13f20eac240adefdd280f6355c23f1213ad260"
    sha256               x86_64_linux:      "1996053d3a5646a7143e1daa8c3256fc26502bba21c9dd82303742832969ff1b"
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
