class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.0.3/gucharmap-15.0.3.tar.bz2"
  sha256 "82636e4a5baacad795430a0de129450e84a69c4b1d68d007128c5023f9a82417"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "9b7d31351e1de102a14324471a47af88a6d2f9e3f7137f3629f51e537f4b0bf4"
    sha256 arm64_monterey: "56036c11acc671e1ea64b6738c028c2f30e62f44d69c7486a4ee2c83ef79f4cc"
    sha256 arm64_big_sur:  "c7fa054afb17f3d139a9448be6dbbcc838870595daf3b9c6d3e0417940d7fbc8"
    sha256 ventura:        "8e80b0e5a5e7996cbd0b67fc15df8fc80ed91da30998f54d46e87fc625fbfa62"
    sha256 monterey:       "6d545e0a772e7c38aa51375c7b5cf580624dffcd1ba3e4c630fe9e08854e1a67"
    sha256 big_sur:        "3aaad8a75f07cc45f5c04a9a38f4a5a7127978d561409dedb0c168e5d65c21e2"
    sha256 x86_64_linux:   "dbaedbda536b85bae704fa15f3d71a2f6bee406ecec19b7e243ccd456aacfb33"
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
    url "https://www.unicode.org/Public/15.0.0/ucd/UCD.zip"
    sha256 "5fbde400f3e687d25cc9b0a8d30d7619e76cb2f4c3e85ba9df8ec1312cb6718c"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/15.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "24b154691fc97cb44267b925d62064297086b3f896b57a8181c7b6d42702a026"
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    (buildpath/"unicode").install resource("ucd")
    (buildpath/"unicode").install resource("unihan")

    # ERROR: Assert failed: -Wl,-Bsymbolic-functions is required but not supported
    inreplace "meson.build", "'-Wl,-Bsymbolic-functions'", "" if OS.mac?

    system "meson", *std_meson_args, "build", "-Ducd_path=#{buildpath}/unicode"
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
