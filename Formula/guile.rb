class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.7.tar.xz"
  sha256 "f57d86c70620271bfceb7a9be0c81744a033f08adc7ceba832c9917ab3e691b7"
  license "LGPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_big_sur: "cd068c29c7c5626c750568d2c44f6325925e41c74e8349905c27908d59f87ad9"
    sha256 big_sur:       "81c12f959793d8fc323af769255cf3b683e5b8140f66e0d660e72191d204c2cc"
    sha256 catalina:      "b54134f18def07d9c6b5462e3117e418a7a7b9691849bda8bbdceb06aa170f6d"
    sha256 mojave:        "199f6ce9864c96277a8580b85fac348e4c67adde6aff8ea601ec5795480bfd03"
    sha256 x86_64_linux:  "afeb29c69df9e25f34767b409f53c832bdacec3a00d25ee9f025139b788e60f5"
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    uses_from_macos "flex" => :build
  end

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libffi"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  uses_from_macos "gperf"

  # This patch fixes an issue where Guile >= 3.0.6 doesn't properly load dynamic
  # libraries on macOS.
  # To be removed after Guile 3.0.8 is released.
  patch do
    url "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=1f100a4f20c3a6e57922fb26fce212997e2a03cb"
    sha256 "a5adf2586b30381cf24524c7fc0364115f7cb1f568d2b69a9f3fb49ad8355b55"
  end

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    # Disable JIT on Apple Silicon, as it is not yet supported
    # https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44505
    extra_args = []
    extra_args << "--enable-jit=no" if Hardware::CPU.arm?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}",
                          *extra_args
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
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix
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
