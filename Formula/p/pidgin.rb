class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  license "GPL-2.0-or-later"
  revision 2

  stable do
    url "https://downloads.sourceforge.net/project/pidgin/Pidgin/2.14.14/pidgin-2.14.14.tar.bz2"
    sha256 "0ffc9994def10260f98a55cd132deefa8dc4a9835451cc0e982747bd458e2356"

    depends_on "intltool" => :build
    depends_on "at-spi2-core"
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
    sha256 arm64_tahoe:   "ae1289bca94151de51149aab865e414377fcd3ce385b1b771c7aec98b87c0387"
    sha256 arm64_sequoia: "e7d8f99958474cadfa8da24b6aca429e53d961af7cd5f3e89f914c833bca21db"
    sha256 arm64_sonoma:  "aaefbd8740d505e3a6460a7ab075954cde0a9890cc5f52b2ca753a5841fa61fd"
    sha256 sonoma:        "72919ceb55d3dbaa92f938e4a2850681a5265933fe27a306859d7f05eecee374"
    sha256 arm64_linux:   "90da19fee3264f2d6a568d87449405fa785219fa39085be9b0e1189d803bf5a0"
    sha256 x86_64_linux:  "fc8acd8bda4c38df7f4bc5b55e15087196689cb5c40ef000bbbd1eb105bfbe69"
  end

  head do
    url "https://keep.imfreedom.org/pidgin/pidgin/", using: :hg

    depends_on "gi-docgen" => :build
    depends_on "gobject-introspection" => :build
    depends_on "gstreamer" => :build
    depends_on "libsoup" => :build
    depends_on "mercurial" => :build
    depends_on "meson" => :build
    depends_on "ninja" => :build

    depends_on "gplugin"
    depends_on "gtk4"
    depends_on "gtksourceview5"
    depends_on "json-glib"
    depends_on "libadwaita"
    depends_on "libspelling"
    depends_on "sqlite"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
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
      --with-ncurses-headers=#{Formula["ncurses"].opt_include}
      --with-tclconfig=#{Formula["tcl-tk@8"].opt_lib}
      --with-tkconfig=#{Formula["tcl-tk@8"].opt_lib}
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
      ENV.prepend "CFLAGS", "-I#{Formula["libotr"].opt_include}"
      ENV.append_path "PKG_CONFIG_PATH", "#{lib}/pkgconfig"
      system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
      system "make", "install"
    end
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas" if build.head?
  end

  test do
    system bin/"finch", "--version"
    system bin/"pidgin", "--version"

    pid = spawn(bin/"pidgin", "--config=#{testpath}")
    sleep 5
    Process.kill "SIGTERM", pid
  end
end
