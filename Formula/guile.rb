class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.2.tar.xz"
  sha256 "1c91a46197fb1adeba4fd62a25efcf3621c6450be166d7a7062ef6ca7e11f5ab"
  revision 1

  bottle do
    sha256 "6c3f5a6df5527562e75c1c9e95dd4e1b0b55ea2d07ab18008ac18cf59492285c" => :high_sierra
    sha256 "f99bf6e5381bcb8c0a77d1eeee51f5a3a10094771cba1e06c6036c66dfcc0181" => :sierra
    sha256 "894296e0f264fb2e9b093dfd2798363ef8ece41e5d92ba9544f65f5690c9c662" => :el_capitan
    sha256 "dd1dbd7d3c0f9c5be7ae5177e7024739026886e9422704b2e561c5ed25f11052" => :yosemite
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
