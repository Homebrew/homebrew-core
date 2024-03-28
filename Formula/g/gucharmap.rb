class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.3/gucharmap-15.1.3.tar.bz2"
  sha256 "fb10d40cb990d4cd835a53a4874e39bb69146409db46a62d03543c1915eec984"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "2070196886ef6c547122b63d378b6b1ea1ed849a22f8eb3f683ee3dd7a80af8f"
    sha256 arm64_ventura:  "2e2b1d2636e3ba31521ea7f60952ee19e39e2cf475393cb221655034790e5879"
    sha256 arm64_monterey: "1280d67990bec09743a336332f71604087e12a67c3cc06f4ad5c3da6bd264e1f"
    sha256 sonoma:         "5d572fe48545bb93826a0ac7b3cd18967f9904070647a69c698b209b8ccf7a08"
    sha256 ventura:        "8a5b29c7155d172a2717d74c05a2362b4f9830702ab9eee51f1d8304b0497d15"
    sha256 monterey:       "a45718d5fe8f5841c53f63d73c2d3b3adb45ba1c3bc0214f7a6d5226f05b2525"
    sha256 x86_64_linux:   "d615b7cc5176058ed8b2166b73f781b86060584f115c3eba3d4d10637b000efe"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gtk+3"

  on_linux do
    depends_on "gettext" => :build
  end

  resource "ucd" do
    url "https://www.unicode.org/Public/15.1.0/ucd/UCD.zip"
    sha256 "cb1c663d053926500cd501229736045752713a066bd75802098598b7a7056177"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.1.0/ucd/Unihan.zip", using: :nounzip
    sha256 "a0226610e324bcf784ac380e11f4cbf533ee1e6b3d028b0991bf8c0dc3f85853"
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
    system "#{bin}/gucharmap", "--version"
  end
end
