class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  url "https://ftpmirror.gnu.org/gnu/guile/guile-3.0.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/guile/guile-3.0.11.tar.xz"
  sha256 "818c79d236657a7fa96fb364137cc7b41b3bdee0d65c6174ca03769559579460"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "badcd01f64dd30d067e31fa2658b3d12760c13b897616200c6e6154e946b3515"
    sha256 arm64_sequoia: "2dec620b6eaf36a87eff83f35bf926145cc8ae8067b0d5469570c4f09bbe4ace"
    sha256 arm64_sonoma:  "efd9a224d852b9378594099290cb21e973c92404bf4f24835e7167b51e3055ed"
    sha256 sonoma:        "253c9d486cccc6e6a9447c484625f7498329cbf16a7c0f28c7beafdd66a24b5a"
    sha256 arm64_linux:   "e9277ab2de50eec2a837d1d0d51456bff3a47737e787e7966df1220ba2b24b74"
    sha256 x86_64_linux:  "be5c49d28eb86b89484e9a5dc33dc4097d9af484b67bde26aae77bf5841771b9"
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
