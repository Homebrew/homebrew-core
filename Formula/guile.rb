class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.3.tar.xz"
  sha256 "8353a8849cd7aa77be66af04bd6bf7a6207440d2f8722e46672232bb9f0a4086"
  revision 1

  bottle do
    sha256 "f5d2b4d9466af132ef010862a6265157caa23e94a482aed8bbf6d3d94b9e207a" => :high_sierra
    sha256 "6a762adf5ff8eee8882a86ef87aa188678208cd43c263fe9877eee182d3d728e" => :sierra
    sha256 "3eb640a61ca351f12478334528370e57464dec7fe18818ef9143f71aad7e6411" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :run # guile-config is a wrapper around pkg-config.
  depends_on "libtool" => :run
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
