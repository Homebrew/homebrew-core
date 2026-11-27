class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.10/flex-2.7.10.tar.gz"
  sha256 "d303c2956792acd8bf3601effef76cadc85a7876852cb66da411c0d5d2f868f4"
  license "BSD-2-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "b7eb67f24bf7433bba3034cc4fee2b60e45c7658ca507cc66599941c90fea93a"
    sha256 cellar: :any, arm64_golden_gate: "c119cdf80b2d52aa4bd6a92d582b47637ea1abaf44e1d54db7a6ab375cc0c9f3"
    sha256 cellar: :any, arm64_tahoe:       "a0fe86b40574ee5990f0c899c2d04e51a96e4801892583af356c318ff1a70d30"
    sha256 cellar: :any, arm64_sequoia:     "15e0d7cad6001bbb32b7b052ecd260d41bc56e0cb78168e78e2a665fa3d2837d"
    sha256               arm64_linux:       "e0edb162eef07505a18580e34ec6f8acbe40278035c01f0a17931974f661e557"
    sha256               x86_64_linux:      "269803cdd0feee1216fa9a8e5a36180d4fc03973ed0cc822f68c5d79383f2069"
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
