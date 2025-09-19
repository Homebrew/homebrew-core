class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  license "GPL-2.0-or-later"

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
    rebuild 1
    sha256 arm64_tahoe:   "72c05493b863e1278527fbb061d93950db72355c80f712a202eb327cee396d1d"
    sha256 arm64_sequoia: "b29a4ae2b61df4ebe31ec8351174e8f827504b755b6d6897278fbbbb3fba47b2"
    sha256 arm64_sonoma:  "56d8ee2c91d79fbc88b8545a9afd844042f21a6ad31451160395858e6b4b6caf"
    sha256 arm64_ventura: "67742939cf4f3c3d2fe6ad7caae0e4006378736a08464340889543d2a5d65157"
    sha256 sonoma:        "90e6291f5817c36034e83bb614e2cb186f3f92a4a7d5dda7ee6a5d2fcc90d25f"
    sha256 ventura:       "577b9023973407ba52c619daa63c75b286a4e700d0b571ce28d0e618b39046bd"
    sha256 arm64_linux:   "a51d7d196fbf4c6b302a1d9b9e5c8beecdba0c6518e3fa49166c830c91c63f9e"
    sha256 x86_64_linux:  "f128c2b0933fb5f28a237b1d96f8d98269d3bdc64ba61531f2e194ed3ea00679"
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
