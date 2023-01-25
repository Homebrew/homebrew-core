class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.9.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.9.tar.xz"
  sha256 "1a2625ac72b2366e95792f3fe758fd2df775b4044a90a4a9787326e66c0d750d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "48357e0f3887432c278fc30c2b85c598c4e696ae0ca0be7666438b14d73479cf"
    sha256 arm64_monterey: "a2318872c5d2c61bc078cc6bb9baf188052a669481908230a9f7a214161de981"
    sha256 arm64_big_sur:  "2df409e1621d404500811fb4a05da8b1574a7b15c429bfc77545b2ce06c5b7ab"
    sha256 ventura:        "176e59c17769821509bc216f0344abaef0a02ee95b8ed8309f1ed5b98e796e12"
    sha256 monterey:       "0f06358bf9c4c00cb9f346b1f8959157143ed8dc460f496cce523582851f5787"
    sha256 big_sur:        "57763df1905d84eb09785df36cdb7341e4fda5c25489457fa9b37d9cdc904510"
    sha256 x86_64_linux:   "10cee80e4a2db3936da4010b891f995e857bf06af986b0f362b1a62f3fda1534"
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    uses_from_macos "flex" => :build
  end

  # Remove with Guile 3.0.9 release.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  # Remove with Guile 3.0.9 release.
  uses_from_macos "flex" => :build

  uses_from_macos "gperf"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    # Remove with Guile 3.0.9 release.
    system "autoreconf", "-vif" if OS.mac? && build.stable?

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
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix if MacOS.version < :catalina
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
