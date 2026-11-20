class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.3/flex-2.7.3.tar.gz"
  sha256 "b18bbc3622b2b9ebecd0423f4e110adfad8db51d0c5ada3f26660c7cb7c735ec"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "34af51504475d725357c2c1fba88bf98a2856412dcef0d22099c118d44d4b202"
    sha256 cellar: :any, arm64_tahoe:       "ef6c79fc9161d190dc8f5ed8741362fa3866c90e6b31fda9edfbf7138c149c7a"
    sha256 cellar: :any, arm64_sequoia:     "290ed496331894f1bab2a2e63f45ffceaed3dab864e2cf843738482abc949a57"
    sha256               arm64_linux:       "8e84dcca3c0ed2554635b216f02bf157a9422be8d00aa9b9c9b360a554a8098b"
    sha256               x86_64_linux:      "67039accddca951f0d70ab3e35a67b3d5032561b912669f55608c46faf9c9f80"
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
