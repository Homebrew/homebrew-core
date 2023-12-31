class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.9.tar.xz"
  sha256 "1a2625ac72b2366e95792f3fe758fd2df775b4044a90a4a9787326e66c0d750d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "079db54f4920bed821e063a1b0dfe05ddc038f220f7b33ec7c8cc64288abc0e8"
    sha256 arm64_ventura:  "802b09beab5de8794ee71ee9556e78347f0d70b76c34fa8bde2799cbe0bdd64c"
    sha256 arm64_monterey: "5bd0d6a721847e049d42e53a5aab7f062ecfd816d5dcf79047fc9cf6e39767cf"
    sha256 arm64_big_sur:  "815898ea4478f76b02c7cf6b87570abb68da29fd07de2a233ee0f7ae95a9bf31"
    sha256 sonoma:         "3c3927f2cfc8dcb57c53753551d9afb6a480cfa4f45a8db116a1a26073a5950d"
    sha256 ventura:        "6d6a9327705cc6d1910b20e6e0d5cf8e9264340302276e2e1be1cbbe32b00fbd"
    sha256 monterey:       "9c0a36654c77db52102d4344be4bd468b5a96482383f65a6a0ab5c6c0ecce29b"
    sha256 big_sur:        "07cfc8d1991c784e5d3a25dd939b6027c7d603e03bdc62c1bb8cb4a2ecb97803"
    sha256 x86_64_linux:   "000f48044f48d7008a21691cf321bb77764dd7ee85e48c8a5088c66514bd9ed1"
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    uses_from_macos "flex" => :build

    on_system :linux, macos: :ventura_or_newer do
      depends_on "texinfo" => :build
    end
  end

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  uses_from_macos "gperf"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    system "./configure", *std_configure_args,
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--disable-nls"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    # This is either a solid argument for guile including options for
    # --with-xyz-prefix= for libffi and bdw-gc or a solid argument for
    # Homebrew automatically removing Cellar paths from .pc files in favour
    # of opt_prefix usage everywhere.
    inreplace lib/"pkgconfig/guile-3.0.pc" do |s|
      s.gsub! Formula["bdw-gc"].prefix.realpath, Formula["bdw-gc"].opt_prefix
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix if !OS.mac? || MacOS.version < :catalina
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  def post_install
    # Create directories so installed modules can create links inside.
    (HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache").mkpath
    (HOMEBREW_PREFIX/"lib/guile/3.0/extensions").mkpath
    (HOMEBREW_PREFIX/"share/guile/site/3.0").mkpath
  end

  def caveats
    <<~EOS
      Guile libraries can now be installed here:
          Source files: #{HOMEBREW_PREFIX}/share/guile/site/3.0
        Compiled files: #{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache
            Extensions: #{HOMEBREW_PREFIX}/lib/guile/3.0/extensions

      Add the following to your .bashrc or equivalent:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
    EOS
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
