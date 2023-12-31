class GuileAT2 < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-2.2.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-2.2.7.tar.xz"
  sha256 "cdf776ea5f29430b1258209630555beea6d2be5481f9da4d64986b077ff37504"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "b2b612f37486f527343dd97bfbf70f7a316a78d1b8cca44286155f18db35fed6"
    sha256 arm64_ventura:  "557aa9ef8f3c8f575122150c28ba59ba9039296ce877ee4682bd4006d90c5b8c"
    sha256 arm64_monterey: "5a1b1e6a6b110db0de83ddd4e8a09aa542bdc956ffcb68929528757e6fd62279"
    sha256 arm64_big_sur:  "c121dcc2dab98dfcbfb1c6007171b64c1b5a7ab13336440d6d8f24a13e26f861"
    sha256 sonoma:         "d2fdc5b4e60062257ba5f7bccfcdd9621f567f419a9d8f80bd704184e03c26b8"
    sha256 ventura:        "4c44b0aa055223c46d33a3025ec363ad0f4bc965b3a4a6bd3f15711cb02b0d16"
    sha256 monterey:       "2e2273836f9912d3e4dd0219f2af761d9fa014f552ecd938acb96af730813be8"
    sha256 big_sur:        "b85baae60da2568229dfcd142067ddd660764e7ac72925279147b68b1269aa4a"
    sha256 x86_64_linux:   "168e8a4a68d97a72f7eb9ba93ab9abcf2e16e2c583e68ae89eaf677a9602cc97"
  end

  keg_only :versioned_formula

  # Original deprecation date: 2020-04-07
  # Temporarily undeprecated from 2022-07-29 to 2023-02-13
  deprecate! date: "2023-02-13", because: :versioned_formula

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
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix if !OS.mac? || MacOS.version < :catalina
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
