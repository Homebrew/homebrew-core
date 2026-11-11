class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.6.5/flex-2.6.5.tar.gz"
  sha256 "4dfb3d6095c0cd58f050dd66fa132ad52c118c5ae26a4bddd916557720920769"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "489e0f8280931fca8ef69641a334950a8bf1a5bac88f26e86869501071bbf579"
    sha256 cellar: :any, arm64_tahoe:       "adf53ab5ca03afd709830039c1ca34751253e336aa5eabab4ee89ad384403667"
    sha256 cellar: :any, arm64_sequoia:     "6d68acd3d2ae032b7e6c19c895d109e30a0d538f044c4613e9ffc45ad3bdb5e5"
    sha256               arm64_linux:       "021f7bf3a4e4ab350e1b4396f34357abccf81f1982807d4ff46584615a6d7c79"
    sha256               x86_64_linux:      "e249d7c43f2a508729abec94692e284ecc3ba74c1b3101be00c9be6f1c4222e1"
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
