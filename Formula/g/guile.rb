class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/gnu/guile/guile-3.0.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-3.0.11.tar.xz"
  sha256 "818c79d236657a7fa96fb364137cc7b41b3bdee0d65c6174ca03769559579460"
  license "LGPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c5217a09fe9edb92bd01541c97db23e71a413fb872f438031ba530d408ea8706"
    sha256 arm64_sequoia: "e9412ea2b150589e74d235f8167026f4985181bd24094ee1e32430f575e47ced"
    sha256 arm64_sonoma:  "04581c5246352a08276404e843a158e2009f93f574becd4dd62b5cc5912c5148"
    sha256 sonoma:        "c5a25d17598f7f205bc98e949b61200eb9fe1de2d25c2a56a96b8c27cd19796d"
    sha256 arm64_linux:   "32d945ee3f4b915f77ef763feb554c7719c613c768fe0c535e79cfd687b67f33"
    sha256 x86_64_linux:  "d294d135b43a05d95e3d17375d89e98eeb0ddb4c967b13b63c20603b95dff1ef"
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
  uses_from_macos "libffi"
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
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix unless OS.mac?
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  post_install_steps do
    mkdir_p "lib/guile/3.0/site-ccache", base: :homebrew_prefix
    mkdir_p "lib/guile/3.0/extensions", base: :homebrew_prefix
    mkdir_p "share/guile/site/3.0", base: :homebrew_prefix
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
