class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.5/gucharmap-15.1.5.tar.bz2"
  sha256 "45c46e854a7de1a6491e6b3b0f3acd6363de1110208bdf5ba88d4e9460e9a897"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "6181ec66a373136d5765f09efc5b5b687c5e5549b0294f2db6cc79e09a9d2a36"
    sha256 arm64_ventura:  "82d10e4ed476e505ab8c1b9427bf81ce7170402f38056cf10d3b91ce0316221f"
    sha256 arm64_monterey: "57d6bc5ff1cdc0668a3dbfae4a79c1d1c36eddaf8b5eb081a9915c4123de493f"
    sha256 sonoma:         "fa4b6775364ca42b9b38a1f6f585eefe12ec7d9e46b741c50297b196494e2588"
    sha256 ventura:        "174846632adfc2bf1c9454ae6a7b9cccbb895805494bb53e07e395975e1eb7ce"
    sha256 monterey:       "7b1d2c6728fa21a5792c3ee9d539e3bf59ff315e9510777d0afa26ea2e05bebf"
    sha256 x86_64_linux:   "d2855332956cb1366282c73fcc3517262981bc33fff198fa20e0ae4b6e6ced66"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.1.0/ucd/UCD.zip"
    sha256 "cb1c663d053926500cd501229736045752713a066bd75802098598b7a7056177"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/16.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "faed0321cf85bbc18fd3edb5f03dbae9d7099ea712d75f08d1fb2f87dcc197e1"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", "setup", "build", "-Ducd_path=#{buildpath}/unicode", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gucharmap", "--version"
  end
end
