class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gedit-tex"
  license "GPL-3.0-or-later"
  revision 3

  stable do
    # TODO: Rename to `gedit-tex` on the next release
    url "https://download.gnome.org/sources/gnome-latex/3.46/gnome-latex-3.46.0.tar.xz"
    sha256 "d67555639b2a15a8aebd54f335354e44fe3433143ae3cb3cca7a8e26f8112ada"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build

    # Backport `tepl` rename to `libgedit-tepl`
    patch do
      url "https://gitlab.gnome.org/swilmet/gedit-tex/-/commit/41e532c427f43a5eed9081766963d6e29a9975a1.diff"
      sha256 "07a4eb459135121cc0228db239eb33183eaad70ef1d19e48e777bfa119a59bf5"
    end
  end

  bottle do
    sha256                               arm64_sequoia: "828431282265734291a78fb6e98982f1f30eca79d7a2127d475c3b09f93b410a"
    sha256                               arm64_sonoma:  "14e7fca07127c9c21270431bab6d5eb2581e66109992289065740731a58bf2e5"
    sha256                               arm64_ventura: "14ad53df41ae72c7e7263c2486723948ae77a1a329ef5e3dcb9d8237120c2c36"
    sha256                               sonoma:        "eaada62390dd85b57ae9ca1db1af02336897e9fa7314952d18660d426d291db9"
    sha256                               ventura:       "f6be8408e82436fd210c48b6f73b5985d23cc055aabe7b63d7688b1f1c70f914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4192833a27f71af1d833f898232841497ebbf0813cd5af240fbcc8ad0e0c7ef"
  end

  head do
    url "https://gitlab.gnome.org/swilmet/gedit-tex.git", branch: "main"

    depends_on "desktop-file-utils" => :build # for update-desktop-database
    depends_on "meson" => :build
    depends_on "ninja" => :build
    depends_on "vala" => :build
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "libgedit-amtk"
  depends_on "libgedit-gtksourceview"
  depends_on "libgedit-tepl"
  depends_on "libgee"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "enchant"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "libgedit-gfls"
  end

  def install
    # build workaround for xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/swilmet/gedit-tex/-/issues/14
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    if build.head?
      ENV["DESTDIR"] = "/"
      args = ["-Ddconf_migration=false", "-Dgtk_doc=false", "-Dtests=false"]
      system "meson", "setup", "build", *args, *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    else
      system "autoreconf", "--force", "--install", "--verbose"
      system "./configure", "--disable-schemas-compile",
                            "--disable-silent-rules",
                            "--disable-code-coverage",
                            "--disable-dconf-migration",
                            *std_configure_args.reject { |s| s["--disable-debug"] }
      system "make", "install"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas",
           "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t",
           "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system bin/"gnome-latex", "--version"
  end
end
