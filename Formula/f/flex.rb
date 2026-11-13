class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.11/flex-2.6.11.tar.gz"
  sha256 "188e9c96b8fc032b2a0bdd24d4f0b692480c1854511c2fcc3034946f14fdf49a"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a030e273c318dd1553a59758e1b2f06c0cce2bd5646c30645a7734ded670870f"
    sha256 cellar: :any, arm64_tahoe:       "a3b45632917c26ff0721e189dad0092dcc74bb77152f2f7545c3384ded096cb0"
    sha256 cellar: :any, arm64_sequoia:     "9793ff67b6bda236665ccb211b9c152edbeda1475d234ea6266045f3a343ca02"
    sha256               arm64_linux:       "10642dd6f14266b56f1726b3b8d53c6c9ae8282a18eb15de25ee48e9d9de2889"
    sha256               x86_64_linux:      "59a79ead9eaae12af0616be7c38eba20077b63bf85e19ff967841a10c6fd77c1"
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
