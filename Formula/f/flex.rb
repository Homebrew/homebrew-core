class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://github.com/westes/flex"
  license "BSD-2-Clause"
  revision 2

  stable do
    url "https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"
    sha256 "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "62ca8b8763bc2c97fe3ec02a4f55e410a6bf80ab26c291b0914313a82d004afe"
    sha256 arm64_sequoia:  "e675e024d2d6f1946303689717a345257cbfc6ba52c20b34447a25b75ae995ff"
    sha256 arm64_sonoma:   "0f7f1fc52a0326f07019c5e90dfc3dd728c69afaffc2e5a75154f132975e8b0b"
    sha256 arm64_ventura:  "900f81d92ac336f0deac4e23141807b77cd15c57460c55ddfafa873d62447d0c"
    sha256 arm64_monterey: "fba3fc3fe93abae2c8c436f0cf2fba194f6cf68e6938496937163c416fe6f402"
    sha256 arm64_big_sur:  "ba78304da35f69526d386e1d1decca8818b155b4dda4f470d9393d23cf713e11"
    sha256 sonoma:         "cebd471efdf0faed6d8fdc615c7637a99bef34e5a21d41f75317d0067ffcc293"
    sha256 ventura:        "d4b974c982ab96f6d372d7e76b0a3965ae2afb084cb533a0abedc840979f78b9"
    sha256 monterey:       "937f34d36419d74cb32ef93df71f5fad1638b2ec5290cb865840e1fcc95ac595"
    sha256 big_sur:        "89ec2b04b1aab94297f490c60fe6ca2bcde7de9b7661482728b07931e635d21c"
    sha256 catalina:       "e563a7a42aceff203cca4f420ebc6a8bbd5075a2b0007d46724f037ebc7b41a5"
    sha256 arm64_linux:    "87601a69b6f78fbd8135aad3717263a9fc4469de7a34418bbffc8b035c8d4837"
    sha256 x86_64_linux:   "b2bff056ad86d8a1cb1a08944867b5f60636ad4e7edca623810937330d87d8eb"
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

  def install
    if build.head?
      ENV.prepend_path "PATH", Formula["gnu-sed"].opt_libexec/"gnubin"

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
