class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  url "https://github.com/westes/flex/releases/download/v2.7.5/flex-2.7.5.tar.gz"
  sha256 "59996449110b7a63544d8e9b84ac49ec6fb442a1595110bf7cc747720b927733"
  license "BSD-2-Clause"
  compatibility_version 1

  bottle do
    manifest_sha256 "f7402bf55fd62fe8aace52b9b1b984a23f7e8e391e1ed1e0facf64ff45002bb0"
    sha256 cellar: :any, arm64_golden_gate: "9ec99fabe2fb679f09c3c124788eeb4f3fa20f6e3bd8facd8bc769d4f766b47c"
    sha256 cellar: :any, arm64_tahoe:       "84c6942721acb5add6551b30f7edaaeefb502e2a13a805c463da4f02afdc2ac4"
    sha256 cellar: :any, arm64_sequoia:     "b789f85a2fd3bef88df9b929b519bdb349c6665050439621b4e5b68818fe3c75"
    sha256               arm64_linux:       "237c6d9fcd6c36b6eba268b2ff6fafbb5675bb3749a3b103cdee402d5055e2cb"
    sha256               x86_64_linux:      "4a918a1d7562b84b82b66893bdcbed7392c6508285e7c3dbc91e801407a542e8"
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
