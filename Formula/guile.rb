class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.2.tar.xz"
  sha256 "1c91a46197fb1adeba4fd62a25efcf3621c6450be166d7a7062ef6ca7e11f5ab"
  revision 1

  bottle do
    sha256 "3e0ae1973c460e01b1614aaf180dec00a4f9032949ee287cb0171e7597a70108" => :high_sierra
    sha256 "3e8f9ea395892b75f3f2ff1d2ea2893bf13377361b9efeee8ef11e6d66f44755" => :sierra
    sha256 "7a6af0696b721d9b157e83d1352d6bc6285000b2471719710d0e190a83389c62" => :el_capitan
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
