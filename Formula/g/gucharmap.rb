class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.2/gucharmap-17.0.2.tar.bz2"
  sha256 "d5aa79bee703846af9ba477803e0fd8c8f63d9c7c522a48e64ebf304bfbfe324"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "5fc83a139aa1bb44ec10100cac01cb80cc6de3b046da3406d2147597ec5a54cc"
    sha256 arm64_sequoia: "13ce180c2332dbda87492fc51ef9ff747464bb03cadbc200650ba01be2f4de16"
    sha256 arm64_sonoma:  "b8df5266fab6c39cdf699ba70535f3184687be314ffdd77677f61d659567b13b"
    sha256 sonoma:        "7a79b0b4a15a78c5e3b2126bc0eafcfff51bb1ec11f05946b098f6db951f9b38"
    sha256 arm64_linux:   "3d44d54def012e053f477f66873c4bd94b750e315332de559ef9aeb856e14319"
    sha256 x86_64_linux:  "4ad31d5c48706a229a6ac584583f06163b431e9b0f98d9df4e59ba6978fe47fd"
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

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    system bin/"gucharmap", "--version"
  end
end
