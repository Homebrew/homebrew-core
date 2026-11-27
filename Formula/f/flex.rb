class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.11/flex-2.7.11.tar.gz"
  sha256 "99a3ede5f61b63bef3136c5cae16d0f453e8d887c18ddc9e50bb01a4db561ace"
  license "BSD-2-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "321514384d57f5f4dd658ff10b1853578a3ceb05841c5e1a3710f2ec757b4797"
    sha256 cellar: :any, arm64_golden_gate: "3cc19608cfb5b3cb8a6b8407ac7d0b19e64b775931be99bb41cf8c3e1ade1f5d"
    sha256 cellar: :any, arm64_tahoe:       "8b8554a9fec780899180642fbafe350cc2033e907244ca0c715201338f1849ec"
    sha256 cellar: :any, arm64_sequoia:     "60a4a9055bbb4024b23e14f8ca7dd9448c0947880ab2357db8a6a4fe2928025d"
    sha256               arm64_linux:       "5f0ad1f9795405903a6b927747bd9820375cc1fe50846ff23b3bfc605a39a2c1"
    sha256               x86_64_linux:      "2533b54ee39467f9388b4c2a6dd3a720134d04ee8ea0558c0308b0b0b2df511b"
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
