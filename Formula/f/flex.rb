class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.1/flex-2.7.1.tar.gz"
  sha256 "336715b27262c7eefab99ba46b06f05e54a1a39d7bc36c79b826a51bbe4fcb81"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "2085216ef641ae2183e9cb03783f225712b6573fe3adccfaf9af96b4345506eb"
    sha256 cellar: :any, arm64_tahoe:       "1ff4303e4dbdc59dc0884604345eecda299d9b61952fd4ccdea79af7a49f9200"
    sha256 cellar: :any, arm64_sequoia:     "6b8963c5a8df612f157594fe85244aa86af3a6867062e9168e6d669852eb9e0a"
    sha256               arm64_linux:       "e556484468526e167253215c9a4dfb7e2346cc4a8de694b50bf2e9336f227a80"
    sha256               x86_64_linux:      "f90f96db7329898e2ea0a1d1083ad59347c767c61cf0184a406f12fbbd6de656"
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
