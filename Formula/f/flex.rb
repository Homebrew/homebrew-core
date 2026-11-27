class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.10/flex-2.7.10.tar.gz"
  sha256 "d303c2956792acd8bf3601effef76cadc85a7876852cb66da411c0d5d2f868f4"
  license "BSD-2-Clause"
  compatibility_version 2

  bottle do
    manifest_sha256 "8db375c781b76fddc9feb08082b49d8d2b84afedf78c086360342bb49747bf48"
    sha256 cellar: :any, arm64_golden_gate: "2684eceffa0b20048879008c1cbb652daa05a4e7f4bf39a7254d195324c2296f"
    sha256 cellar: :any, arm64_tahoe:       "f14daad4d848eb931309d2bd8bbda6e5130ba890027afe1c01bcaef1e7478e91"
    sha256 cellar: :any, arm64_sequoia:     "3b957e587ae6ba3a485248d3b5e7ad0eeed3cf62cea47c007bef5ef6844b87a3"
    sha256               arm64_linux:       "7ab318d0c3f4b13eac430e2476d291b3358618e67b6b9f19b8dbf0dd4063a35f"
    sha256               x86_64_linux:      "5bbaf217c1c1f92bb1cdd9e3d1049a830566562e474db0414a1fe39d69fae61d"
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
