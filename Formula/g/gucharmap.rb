class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/16.0.2/gucharmap-16.0.2.tar.bz2"
  sha256 "f320ad67318dbf0ec26691849c0fe8f5ef4d72e6e78873fb083ad12c94bcda00"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "11517c190dbe6ac8cee546e89ba36df310d0fa838ed7636437f95155d2b62874"
    sha256 arm64_sonoma:  "fc21d70b9319bbadcc227107d7987e46c3474fbdea88ec219ec27051176f472c"
    sha256 arm64_ventura: "f884c900fdba9a0a8bf52f00c5a3ec68db46fabec8f4ef4ac1faa8115f7afdbd"
    sha256 sonoma:        "4ff534da40aab00d5b36677697e061e465288eb59dcab160b26b85da15a6d2a3"
    sha256 ventura:       "ac90916e94ae7ffc4480793575cc9dc6555463335283252499a30663bb4521b8"
    sha256 arm64_linux:   "f6d5fbf4a6dbc49ff25dd11bb69e58c07f2f654bbcdc8712b5ebe8880978246a"
    sha256 x86_64_linux:  "15d7d8cc50e776aeb271dc07d659815ed08a4fbe5c9cc58cc315b6798b4f01e3"
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
    url "https://www.unicode.org/Public/16.0.0/ucd/UCD.zip"
    sha256 "c86dd81f2b14a43b0cc064aa5f89aa7241386801e35c59c7984e579832634eb2"
  end

  resource "unihan" do
    url "https://www.unicode.org/Public/16.0.0/ucd/Unihan.zip", using: :nounzip
    sha256 "b8f000df69de7828d21326a2ffea462b04bc7560022989f7cc704f10521ef3e0"
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
