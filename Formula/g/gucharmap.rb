class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.1/gucharmap-17.0.1.tar.bz2"
  sha256 "97a642e21d06b295066585e91e6724d622e2b2e952a725e417f81cb0fde9c2ac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "be63668906495a166bf7fba3bf2c6934156791077727d35cdd5b3232de3a3b9a"
    sha256 arm64_sequoia: "f505d01b679d784848c206475806734dcd659a3e9dd00c3cf2b806347a18d7ed"
    sha256 arm64_sonoma:  "61ae581eebba3fccf8cb8de6c0ccf77fd522f7717902be8c8d4b606c31cdece9"
    sha256 sonoma:        "7adc754a73ba22204e404aed4de0f119ea688902916eff2ab7dc4d864df83896"
    sha256 arm64_linux:   "18b151f0dcc03ca2da3ec497ca5067d711fcbf92f05f101dc5c2c71bd57bc8b8"
    sha256 x86_64_linux:  "47392c0b0162a982044fce34044771065b7d864b2857a04644936ee425e175a6"
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
      url "https://www.unicode.org/Public/"
      regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
    end
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/17.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "f7a48b2b545acfaa77b2d607ae28747404ce02baefee16396c5d2d7a8ef34b5e"

    livecheck do
      url "https://www.unicode.org/Public/"
      regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
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

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gucharmap", "--version"
  end
end
