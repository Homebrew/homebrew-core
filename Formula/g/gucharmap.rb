class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.1/gucharmap-15.1.1.tar.bz2"
  sha256 "f05b21586e6a762fb01561892b48f917230f29a115aa7f8405396843feccc9de"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "4ad7319a7b8d3c6658fbc6ea024ae6c9486d1d438270d3c0d7af785cbecab249"
    sha256 arm64_ventura:  "7f790825f16db96d6f9f15da97e27b0e66c8f3ebbfbf437e2d47d27ba4bbec77"
    sha256 arm64_monterey: "30a69554b2edce6e814d6c74d496f7e4a64a809480521b1f02dd4ed0e41fd0d0"
    sha256 arm64_big_sur:  "9913003890e70cbbb7bfab1bb46fd306a24b96cb58d646a9fb04328dc47599d4"
    sha256 sonoma:         "ecb387151903f8fea45bb93fe952e4fc813f36fc2692b06b783a23dec1b3a16c"
    sha256 ventura:        "cddcd3d7af5cea1520327372f99235e7c3661e476c810dcd3d63fbd60ca41ae7"
    sha256 monterey:       "66eea725ac33e1a862804eaf09334805ca958984901b1451bbe21da002eda5b6"
    sha256 big_sur:        "8db37062d45f502c9b98132d5ea9f6c928d3e0d7ea1a95d6f5a1b890239cbb4b"
    sha256 x86_64_linux:   "fbe16b6ad2dadf10b11518175eb1865b9a3c35c890fa5bc49f503d9dd3c6f361"
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
