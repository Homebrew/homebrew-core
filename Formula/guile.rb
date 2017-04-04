class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/guile/guile-2.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-2.2.0.tar.xz"
  sha256 "c18198ff6e8b05c620dbdd49b816a2e63a2688af843b5cf8e965041f1adcb515"

  bottle do
    sha256 "6f75b9defe2af4b88da18f37e4ee1e51ad2a8fd30f97993bb47fdee6c567c09c" => :sierra
    sha256 "1484efe6e4ce820c04f1937b0efa1f33a4576b6eddb445f12205674e4b90ef18" => :el_capitan
    sha256 "cafb17a5cfa061aeb11a6afb61374279e0940b0be8b6e11a708c65f16b4559fb" => :yosemite
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
