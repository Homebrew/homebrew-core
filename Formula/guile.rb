class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.4.tar.xz"
  sha256 "d9e8b94af7b206fcf52bec6501b921bd7d0bd7a31fb7e896a35ba8253678e31e"
  revision 1

  bottle do
    sha256 "8eb39acfde1c0c82c462e737f9e577ceacedf0e4ad8b23e4aaf9c7044be25b2c" => :mojave
    sha256 "1a0b7b04830b2a0b3012b71573a1d297a7bcb2ae40d072c8c0f7aff854e19f55" => :high_sierra
    sha256 "02f9d024e545abf7fb1dfd328d33cd0f33870eec5df964adf9469c5e11715a77" => :sierra
    sha256 "035fb8fddf3768a35d74a9003b26fe864184d2f5ce7b53f876e57ec28b667cf8" => :el_capitan
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
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
