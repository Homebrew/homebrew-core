class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.5/flex-2.7.5.tar.gz"
  sha256 "59996449110b7a63544d8e9b84ac49ec6fb442a1595110bf7cc747720b927733"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "a6e606172c04d841a89323b4fd0ffa7cc4d57783b82f67568bc5aedc73852a16"
    sha256 cellar: :any, arm64_golden_gate: "73571b01d295259ca0923688422be33ec356b2d64d4437b9a175192554700280"
    sha256 cellar: :any, arm64_tahoe:       "0d31545ea6de4114ac075e3dc3a593f10d3a2cdf7b1bf624995dbef262e89dde"
    sha256 cellar: :any, arm64_sequoia:     "da6f0948d697e18b9f403c51ee801b09ef099a4c0fd5deadb767b61f190047dc"
    sha256               arm64_linux:       "f81458350341bb7fe1b3a12ce716a573896c1ac9ac3da0e950985f7ec0070cb3"
    sha256               x86_64_linux:      "7bccd153d4d13f68288d0a68204baf716de31562ed44aaa0519a132633415853"
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
