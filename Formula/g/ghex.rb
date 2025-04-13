class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/46/ghex-46.2.tar.xz"
  sha256 "a8f276a36397a70d20b862ff7c664243d9cf2891deb9be06d745a4f1ac661f31"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sequoia: "9f3d7eaae9229a7eeb0b05d4bdf6190331bc4733b3f25d93be229b16aef43514"
    sha256 arm64_sonoma:  "d8e784d52ed1d669a06632cb8b4c195f1f7927c2bd9a6e048615954667937485"
    sha256 arm64_ventura: "94b836df614cf6f09d204759900e00ad7f14e5914ecdb9668001ea6a1914371d"
    sha256 sonoma:        "4c3099c37fbcb98de1247b0c6caf23c78bdad02c036c3b39507a78f919b132b7"
    sha256 ventura:       "04ef90cbd4c7a30f3b4d52a009063ea7e7a9d7cddd55774114cd09d6bb790a8c"
    sha256 arm64_linux:   "e59d379ffbb932f68cbab826a4f6a2d87e230257aaaa8002c38f342a4b42c53f"
    sha256 x86_64_linux:  "1535e97c43be3145b20d0e116ce225e733ab8757c6e626612a89cb823fc25db7"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    # (process:30744): Gtk-WARNING **: 06:38:39.728: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"ghex", "--help"
  end
end
