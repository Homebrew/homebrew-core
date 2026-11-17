class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.16/flex-2.6.16.tar.gz"
  sha256 "c778edc11a53b86aa33203f51d179cc294e5a5d07f84285eaa34c76c3f902bab"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf17d29ee1b0a16f31cf3cfc71e8d99cea53b476b0e01dfdbf6478c61e6b6e08"
    sha256 cellar: :any, arm64_tahoe:       "e3f0ae8f5b89e885134b15064bc327ad98c5179a167d2ecca1e7a39620848691"
    sha256 cellar: :any, arm64_sequoia:     "db4fac262d7f0725b868f928bf4db424f512b01ae82582af7a397384c27d8985"
    sha256               arm64_linux:       "1b1b68fb080d7ca76b6b4a9fd3febb0fc1fd1a98849646c752dd6ff7dc61aab5"
    sha256               x86_64_linux:      "11020a21d4996e7e78c0bdb1fc55f1143e79aa9e228ac4a80991ae9b0561ac20"
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
