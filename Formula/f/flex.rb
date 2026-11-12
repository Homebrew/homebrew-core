class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.10/flex-2.6.10.tar.gz"
  sha256 "a20ac08f4b88f7250818cac2b9609cbea29c47d79e42b79c188c23f2236f8145"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "72617b5e2d185732a2c1c7703e5758b17b48d5c67e9b0225390d717b94fada12"
    sha256 cellar: :any, arm64_tahoe:       "c47c74df220f5ef502b1b709044e862426e9f0a427d268ec8db1abd4d67c68c1"
    sha256 cellar: :any, arm64_sequoia:     "b770d6a11f49137168d54a5eb2da13f3147b01459d193b43a463e524a466c618"
    sha256               arm64_linux:       "f008815508f72133abb5031ebbdcaec4fb30e27b74b52d25cba542860ddf256f"
    sha256               x86_64_linux:      "3840382f828e5b977184be20a0893cba59cfd76eec291cb81d90f437f869784e"
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
