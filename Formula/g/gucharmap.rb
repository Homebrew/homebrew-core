class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.2/gucharmap-17.0.2.tar.bz2"
  sha256 "d5aa79bee703846af9ba477803e0fd8c8f63d9c7c522a48e64ebf304bfbfe324"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "09cb32a02e2edb50223d4f9ebe8412245e9c83891e5a3fb2a490268a7bcbb8b0"
    sha256 arm64_sequoia: "fdcad739389029c24449e013293d83fa598de25b676ce79fb6552482a3eddada"
    sha256 arm64_sonoma:  "61ff6905c2c143cbfc0db25c2dd130a488acae6fee1f38df06b73cc419e2bb1c"
    sha256 sonoma:        "7bfd643c6ea7027e1ff9b0fb33f6d70535deed333b55107e3b6278c417b154ed"
    sha256 arm64_linux:   "28d9ab835720e30da0ca28cb2ca9622f7601c64181589e5d8efb702d0b90c4e2"
    sha256 x86_64_linux:  "daca552d1c157d3b348489af518a968aa9e3e5122d507db32db78866a1994509"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk-doc" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
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
    url "https://www.unicode.org/Public/17.0.0/ucd/UCD.zip"
    sha256 "2066d1909b2ea93916ce092da1c0ee4808ea3ef8407c94b4f14f5b7eb263d28e"

    livecheck do
      url "https://gitlab.gnome.org/GNOME/gucharmap/-/raw/#{LATEST_VERSION}/gucharmap/unicode-i18n.h"
      regex(/UCD\s+version\s+(\d+(?:\.\d+)+)/)
    end
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/17.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "f7a48b2b545acfaa77b2d607ae28747404ce02baefee16396c5d2d7a8ef34b5e"

    livecheck do
      url "https://gitlab.gnome.org/GNOME/gucharmap/-/raw/#{LATEST_VERSION}/gucharmap/unicode-i18n.h"
      regex(/UCD\s+version\s+(\d+(?:\.\d+)+)/)
    end
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

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    system bin/"gucharmap", "--version"
  end
end
