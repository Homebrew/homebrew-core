class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  license "GPL-2.0-or-later"
  revision 3

  stable do
    url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.14/pidgin-2.14.14.tar.bz2"
    sha256 "0ffc9994def10260f98a55cd132deefa8dc4a9835451cc0e982747bd458e2356"

    depends_on "intltool" => :build
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gnutls"
    depends_on "gtk+"
    depends_on "libgcrypt"
    depends_on "libgnt"
    depends_on "libotr"
    depends_on "ncurses" # due to `libgnt`
    depends_on "tcl-tk@8" # ignores TCL 9

    uses_from_macos "cyrus-sasl"
    uses_from_macos "expat"
    uses_from_macos "perl"

    on_macos do
      depends_on "harfbuzz"
      depends_on "libgpg-error"
    end

    on_linux do
      depends_on "perl-xml-parser" => :build
      depends_on "libice"
      depends_on "libsm"
      depends_on "libx11"
      depends_on "libxscrnsaver"
    end

    # Finch has an equal port called purple-otr but it is a NIGHTMARE to compile
    # If you want to fix this and create a PR on Homebrew please do so.
    resource "pidgin-otr" do
      url "https://otr.cypherpunks.ca/pidgin-otr-4.0.2.tar.gz"
      sha256 "f4b59eef4a94b1d29dbe0c106dd00cdc630e47f18619fc754e5afbf5724ebac4"
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/pidgin/files/Pidgin/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+)/?["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_tahoe:   "07fabdb8ecdca7fc63c9ed7118991e5ebbc54b23ebc3bc76a6ded44e5252948c"
    sha256 arm64_sequoia: "f71d36dc27fc785264411d14d3228872361adf6df96630519e0a5d4b2d53d8d5"
    sha256 arm64_sonoma:  "0a29c46da632237c790463a6212d7a338a0df3917cd61dc1cbd24458db4a7a51"
    sha256 sonoma:        "17e02b2a71fe1fead33d12be64f57757b65c14874dad2b6a17b054ef4df36f74"
    sha256 arm64_linux:   "b6351202b70a03c5ff1b1f8747753706415c016b8488a8723ea3f42cb6978e27"
    sha256 x86_64_linux:  "e2e305b1a67c27a3a59c42f9285b93cb1c410c7ca7e7e0dbc29279561caeb59e"
  end

  head do
    url "https://keep.imfreedom.org/pidgin/pidgin/", using: :hg

    depends_on "gobject-introspection" => :build
    depends_on "gstreamer" => :build
    depends_on "mercurial" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build

    depends_on "gplugin"
    depends_on "gtk4"
    depends_on "gtksourceview5"
    depends_on "json-glib"
    depends_on "libadwaita"
    depends_on "libsoup"
    depends_on "libspelling"
    depends_on "qrencode"
    depends_on "sqlite"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "libidn"
  depends_on "pango"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    if build.head?
      # TODO: Patch pidgin to read plugins from HOMEBREW_PREFIX similar to stable build
      ENV["DESTDIR"] = "/"
      ENV["GI_GIR_PATH"] = HOMEBREW_PREFIX/"share/gir-1.0"
      system "meson", "setup", "build", "--force-fallback-for=birb,hasl,ibis,seagull,xeme", *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
      return
    end

    unless OS.mac?
      # Fix linkage error due to RPATH missing directory with libperl.so
      perl = DevelopmentTools.locate("perl")
      perl_archlib = Utils.safe_popen_read(perl.to_s, "-MConfig", "-e", "print $Config{archlib}")
      ENV.append "LDFLAGS", "-Wl,-rpath,#{perl_archlib}/CORE"
    end

    if DevelopmentTools.clang_build_version >= 1600
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types -Wno-int-conversion"
    end

    args = %W[
      --disable-avahi
      --disable-dbus
      --disable-doxygen
      --disable-gevolution
      --disable-gstreamer
      --disable-gstreamer-interfaces
      --disable-gtkspell
      --disable-meanwhile
      --disable-vv
      --enable-consoleui
      --enable-gnutls
      --with-ncurses-headers=#{formula_opt_include("ncurses")}
      --with-tclconfig=#{formula_opt_lib("tcl-tk@8")}
      --with-tkconfig=#{formula_opt_lib("tcl-tk@8")}
    ]
    args << "--without-x" if OS.mac?

    # patch pidgin to read plugins and allow them to live in separate formulae which can
    # all install their symlinks into these directories. See:
    #   https://github.com/Homebrew/homebrew-core/pull/53557
    inreplace "finch/finch.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/finch\""
    inreplace "libpurple/plugin.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/purple-2\""
    inreplace "pidgin/gtkmain.c", "LIBDIR", "\"#{HOMEBREW_PREFIX}/lib/pidgin\""
    inreplace "pidgin/gtkutils.c", "DATADIR", "\"#{HOMEBREW_PREFIX}/share\""

    system "./configure", *args, *std_configure_args
    system "make", "install"

    resource("pidgin-otr").stage do
      ENV.prepend "CFLAGS", "-I#{formula_opt_include("libotr")}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    system bin/"finch", "--version"
    system bin/"pidgin", "--version"

    pid = spawn(bin/"pidgin", "--config=#{testpath}")
    sleep 5
    Process.kill "SIGTERM", pid
  end
end
