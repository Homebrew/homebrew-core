class Pidgin < Formula
  desc "Multi-protocol chat client"
  homepage "https://pidgin.im/"
  license "GPL-2.0-or-later"
  revision 1

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
    sha256 arm64_tahoe:   "7e57a96931ebf4331d9e429d649c24cfb781342c8356f53fb5e87b2b5ccc2131"
    sha256 arm64_sequoia: "b274e4be4235e883361877f9aef080150c936daa8d29f849376543b7116ed10a"
    sha256 arm64_sonoma:  "40c27f8bfded66c59d66f242b1ef846d54efd204a2f7a710f201cc06c6d26f4e"
    sha256 sonoma:        "fd1b484ceea26e769f0aff6f7ddb358a8eb5cec30ebb9a4104aa073c4e0a330b"
    sha256 arm64_linux:   "5fdce57c60203e4e3a232df20fadd7bb1f97cb07c681a71fa40821b0df16203f"
    sha256 x86_64_linux:  "814d3e0a391206920f3c8d4b07d3c6b117cb4bfc91993351037399a4ae958f79"
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
