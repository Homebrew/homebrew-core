class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftp.gnu.org/gnu/guile/guile-3.0.8.tar.xz"
  mirror "https://ftpmirror.gnu.org/guile/guile-3.0.8.tar.xz"
  sha256 "daa7060a56f2804e9b74c8d7e7fe8beed12b43aab2789a38585183fcc17b8a13"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_monterey: "dc6e5dccbc34d5171fba0bc0a0f96381dad52a9837b6f0a1aa6eba2851b6137d"
    sha256 arm64_big_sur:  "f8f697d08fcdc49218fb1a5f708c465e99c0da8ab94d7af8811cd15ec3b22370"
    sha256 monterey:       "0d57e1c9dac0badc33a6355444a09c27a5eb79d1eec1ea1afc591b09f964f125"
    sha256 big_sur:        "e95549a938b1c83eadfd102fd1eeea423416425249825330f607dbaa9ed8bc9b"
    sha256 catalina:       "13c2dbd3e20e04169c5bc3047b4f6bec0dd19d0fc7bf6ef5f7f48b917eff008b"
    sha256 x86_64_linux:   "0a6685530111e6091bd640f119603b6a2f4cb70bfb8cd70532577898a9dbd91b"
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
