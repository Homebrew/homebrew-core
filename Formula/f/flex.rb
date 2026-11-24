class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.7/flex-2.7.7.tar.gz"
  sha256 "4fff8a32ce095788537fdc4dbecd04ec069110c84429d182259f108db1003db2"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "4a8ba867c404925325e7627f7c0bf11dc3b1742c7de0f07e842fabb94d677521"
    sha256 cellar: :any, arm64_golden_gate: "ac057fe506079bbfcca8375db9a2ad6446ebc9be1e2619929479b87653dc0c32"
    sha256 cellar: :any, arm64_tahoe:       "238e9bc47470a9faec05eb438395edca7909b6af0a2908d34c375e5187316abc"
    sha256 cellar: :any, arm64_sequoia:     "9ee4923e8c9e4b22439d33ed8a788c2c2ff91b610bfca4acddecbe1ce6ac987f"
    sha256               arm64_linux:       "f6692692ad1f374e36b08673fdd3deb8a99f20bdaf286036567ea3b9d4f16a87"
    sha256               x86_64_linux:      "a35c96d56c28214b4d0816ec8cda4e5fdb92b4bbb070eadb831f96e99e0ee72e"
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
