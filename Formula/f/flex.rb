class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.12/flex-2.7.12.tar.gz"
  sha256 "4a9de7f658d6e6c07cc6d309a6bb99395db0d1980a03ff05255126c070142c99"
  license "BSD-2-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "f974f038bb4e98218f6c58beeecf9c2a1b1c8fa2d6e526957abca935a9ea999d"
    sha256 cellar: :any, arm64_golden_gate: "847278642099bbc9ad072434a1266fa44856b086a5d96b489f7fd1ce53469e81"
    sha256 cellar: :any, arm64_tahoe:       "c796a22cb60ab36653e1888c7100f1963e2eba662197780e5d509cc36cbda55d"
    sha256 cellar: :any, arm64_sequoia:     "242c05ad6325b5c0819e7e4528875bf960844e916dbba4a575c95f038a34c5bf"
    sha256               arm64_linux:       "4788591267c0ae2f67814a4cb595037cf07c1937485d862042823ec56f2e073f"
    sha256               x86_64_linux:      "012a210f4480241f498e1efd55de417d8cd9d900b751ab7af897a065ebb2b43c"
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
