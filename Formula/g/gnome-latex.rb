class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://gitlab.gnome.org/swilmet/gedit-tex"
  license "GPL-3.0-or-later"
  revision 2

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
    sha256                               arm64_sonoma:   "07b18470a11071e313f759a79419c31fd439027b51b016de4254bc6c78fac423"
    sha256                               arm64_ventura:  "852245582998816a39ba87f16633e0cfd1aa6ae72fec41411237ee2c13fc01f5"
    sha256                               arm64_monterey: "92ef5b78c6db335ff67ce5467137ba00d96f9928d458f0a5f3d455779d5f6c5d"
    sha256                               sonoma:         "28961e66d0fbf8408c0454a6e950006a7f5ff97d5e87d399c79d57d657521492"
    sha256                               ventura:        "28a5eb18bd5e82c6ad451c3b259baa5bacfa391b628fe8bd38814c2d686c6235"
    sha256                               monterey:       "3d8b295155ea8f76e5d2d7d3e74a0e72e5ded81cdd20a5b4ca16b2187098ea1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8281dbcc2d48a6b955f832a01947da7b5b27b536b2e650c36cddf6ec807e1116"
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
