class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.10.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.10.tar.xz"
  sha256 "bd7168517fd526333446d4f7ab816527925634094fbd37322e17e2b8d8e76388"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "bacc4d4dca5374f7a713747ad70fb2111f8c3b443f2a5fb614f05b659be80949"
    sha256 arm64_sonoma:   "e7f65709dffaf55c7ace2e1c8f6553aebc56a17674b7ab57421c1f22bbf7798a"
    sha256 arm64_ventura:  "8e47adc1f7238e67c3af7712ff0e57c1d0b1b79a86950f0e0370944f1a69c960"
    sha256 arm64_monterey: "d58266c28fa037d004ddcd50f5da744a7232303455139523f61a83a3d36ce5e6"
    sha256 sonoma:         "4b8013bda989e3215cbe659f8e0786408f8e71a56777c1533a882246e986cdf8"
    sha256 ventura:        "48cf5388ba5c114888987ae31a6620d640ed94c72e22076df491c33a88a35deb"
    sha256 monterey:       "2716185a062154262f1b160358fa955bf31bbdae5d0b08f4d0c38e3bf6ff066c"
    sha256 arm64_linux:    "d2c305fc8941ee39d4b7a4ea7ea5f3f6257d5ed67fd4fbae31bf5ad44a2f6411"
    sha256 x86_64_linux:   "fd3f68416f1b61d67641e43ce42a3a4b88ad5a010533b572b42e69fa8e4ef434"
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
  depends_on "pkgconf" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  uses_from_macos "gperf"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"

  def install
    # So we can find libraries with (dlopen).
    ENV.append "LDFLAGS", "-Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkgconf"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    system "./configure", "--disable-nls",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}",
                          *std_configure_args
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
    hello.write <<~SCHEME
      (display "Hello World")
      (newline)
    SCHEME

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
