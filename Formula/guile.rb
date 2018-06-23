class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.3.tar.xz"
  sha256 "8353a8849cd7aa77be66af04bd6bf7a6207440d2f8722e46672232bb9f0a4086"
  revision 1

  bottle do
    rebuild 1
    sha256 "e696caf8a6b77e536dc9d012662bb2625ea5b5b2d4a75562ed506b1f922e9cb2" => :high_sierra
    sha256 "0d7fcb978879b79afdad703987f25889a0d64184e3ce0a195d1d66f6c23d34a1" => :sierra
    sha256 "f9e34f08ee74177b69614a7b7dd2fd5df5294d7b0fd7b49f6359b6c111e99bfc" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "libtool"
  depends_on "libffi"
  depends_on "libunistring"
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "readline"

  fails_with :clang do
    build 211
    cause "Segfaults during compilation"
  end

  def install
    system "./autogen.sh" unless build.stable?

    # Fixes "sed: -i may not be used with stdin"
    # Reported 7 Jan 2018 https://debbugs.gnu.org/cgi/bugreport.cgi?bug=30011
    inreplace "libguile/Makefile.in",
      /-e 's,\[@\]GUILE_EFFECTIVE_VERSION\[@\],\$\(GUILE_EFFECTIVE_VERSION\),g'      \\\n         -i/,
      "\\0 ''"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    # This is either a solid argument for guile including options for
    # --with-xyz-prefix= for libffi and bdw-gc or a solid argument for
    # Homebrew automatically removing Cellar paths from .pc files in favour
    # of opt_prefix usage everywhere.
    inreplace lib/"pkgconfig/guile-2.2.pc" do |s|
      s.gsub! Formula["bdw-gc"].prefix.realpath, Formula["bdw-gc"].opt_prefix
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<~EOS
      (display "Hello World")
      (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
