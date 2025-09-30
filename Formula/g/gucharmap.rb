class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/17.0.0/gucharmap-17.0.0.tar.bz2"
  sha256 "09988f67ae82d057a993ab21df2ac94503a8a836da5f8e36e5e8864d8d45a295"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "8eda1a0d1363881e6ce862e9b133ab84e71900b2400c22bf916474a2027622e5"
    sha256 arm64_sequoia: "28e1ea688e0d6a71c62948d83d1b6151d4e8fd7b9ab483bd5e9454becf84891c"
    sha256 arm64_sonoma:  "efe42a71223e43dee68587b0eb49ba54a45d15679a22152f42c0a9fcbe1eff11"
    sha256 arm64_ventura: "5aa1785f4e513bc8481c4fe20075a01f4de266ce6b1c96991ebceda6f000b2d7"
    sha256 sonoma:        "2e508cbe8717864fb0cf55ee46fec65a16e1824ad4a06f07017a769fb6685104"
    sha256 ventura:       "36643374a214f7d74be7a5b0e502a4b50867cb26f4c5e787e964932cb9a3eadf"
    sha256 arm64_linux:   "4887b1b08bd932768200fc53dd969aaf28d11c45b949f01951315ae2c4d7aca9"
    sha256 x86_64_linux:  "376bfa0062c3f722980799b7e50c9f7efc51ad4ed79078b3cd4ab79c4eef5a35"
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
