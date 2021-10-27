class GuileAT2 < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.7.tar.xz"
  sha256 "cdf776ea5f29430b1258209630555beea6d2be5481f9da4d64986b077ff37504"
  revision 1

  bottle do
    sha256 arm64_monterey: "ff0c7976f8d78bbcb0ee5f6425b2c937dcd2fd82b711a0eea116dcd2321fb1fd"
    sha256 arm64_big_sur:  "cc8e116bdef0157cc6ec1a353464d4d9b0441aad4d3056f843bbcfae7590e51b"
    sha256 monterey:       "239da930db7fc29d675df66a5d615ae55b278aa0e8889b08c9b71219ae20d874"
    sha256 big_sur:        "f64b911916df32bf5b566f563d49d72fad81c9fac5ba564d761c779137abc750"
    sha256 catalina:       "580931e21ffeaeb0c3d86e97a7356f098a1b23bcabd7757fcb49a9501698f422"
    sha256 mojave:         "8c06caa2fd6aa55edc961ca1fb0df5865139e983ea6f331dd469215fab3d3661"
    sha256 x86_64_linux:   "8ec924ab98052343af654b8ae9f75f21ebb81267b44bcc0b796b24f0731435ee"
  end

  keg_only :versioned_formula

  deprecate! date: "2020-04-07", because: :versioned_formula

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

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
