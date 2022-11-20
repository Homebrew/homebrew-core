class GuileAT2 < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.7.tar.xz"
  sha256 "cdf776ea5f29430b1258209630555beea6d2be5481f9da4d64986b077ff37504"
  revision 2

  bottle do
    sha256 arm64_ventura:  "97c512b6352e46223d1d499ccbd2280177a66d6f9076fadbabf2bd84b5125b08"
    sha256 arm64_monterey: "1de3f7d4c718fd2122bd3360eb8317b9df884799b80c7df0aa22bce7a8747f1b"
    sha256 arm64_big_sur:  "c781109b4f185f2398a88e947b2b295ee8f19d345286b66c288dc10d12eae491"
    sha256 ventura:        "1a43acde3b34779a6839ce2c3ee779b729172688ffd22ce6d7e24f8018f1a0b7"
    sha256 monterey:       "4761b93580c0728f4f24b710aad17f6e00c5ad8db43068fbf59aa1ff8836897c"
    sha256 big_sur:        "aef48eb8b76fe89a8562a05aea4d749b40e229f15171975e07450c6b0c3b97ff"
    sha256 catalina:       "400b13228b43277fda50549b52a7c7416a81072fb512c2d2caafd54a35646b53"
    sha256 x86_64_linux:   "e494b466134fd8d9b2a0dc512dd8814192c9a621fdb52bbdd45e6aeac29c1a3f"
  end

  keg_only :versioned_formula

  # Commented out while this formula still has dependents.
  # deprecate! date: "2020-04-07", because: :versioned_formula

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    lib.glob("*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    # This is either a solid argument for guile including options for
    # --with-xyz-prefix= for libffi and bdw-gc or a solid argument for
    # Homebrew automatically removing Cellar paths from .pc files in favour
    # of opt_prefix usage everywhere.
    inreplace lib/"pkgconfig/guile-2.2.pc" do |s|
      s.gsub! Formula["bdw-gc"].prefix.realpath, Formula["bdw-gc"].opt_prefix
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix if MacOS.version < :catalina
    end

    (share/"gdb/auto-load").install lib.glob("*-gdb.scm")
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
