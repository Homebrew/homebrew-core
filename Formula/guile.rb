class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/guile/guile-2.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-2.2.0.tar.xz"
  sha256 "c18198ff6e8b05c620dbdd49b816a2e63a2688af843b5cf8e965041f1adcb515"

  bottle do
    sha256 "1de107828ea1d6eb5448b56c9ddca985fdb36b89d0de77390d4a70a04581c964" => :sierra
    sha256 "d8fc01107161424ecf8c22bb2e1bc074b5805d70c2a0525c604996112c945fa7" => :el_capitan
    sha256 "e994c1c0ca0bf0f84d91838f2bf992eda7ada179b7eef6bbd4583fd74ce79fc9" => :yosemite
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
    hello.write <<-EOS.undent
    (display "Hello World")
    (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
