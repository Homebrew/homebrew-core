class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.6/flex-2.7.6.tar.gz"
  sha256 "d7aedd600702e6a42d221f799bcd10c274254fbfafab49b6fb9c03573e3d92de"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "d04291a9ba86603dfce1187d05b56ab81b2c578500c2fb115f1f2276534fe99d"
    sha256 cellar: :any, arm64_golden_gate: "2c0e591984caa3bcf51a5488ef96151866075c0e55e140f8ceda18d060305e27"
    sha256 cellar: :any, arm64_tahoe:       "e3d553c1700f3cab89002c878ee553a8c61a58538221eb3bbaa82cf4a39d12b1"
    sha256 cellar: :any, arm64_sequoia:     "633d513451d953d570eeb490935b1e34b42066f54685e8afe972ebbb2629913b"
    sha256               arm64_linux:       "4d00b5fe3393438fbd1a0098b11664a2cb4cd845ffcdd027b2394f25a144dfbd"
    sha256               x86_64_linux:      "e9e2ac2a085288524d2816e3da78ffc577d7bf232306d615bdcf0da5bc879579"
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
