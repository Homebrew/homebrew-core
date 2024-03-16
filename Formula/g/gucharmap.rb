class Gucharmap < Formula
  desc "GNOME Character Map, based on the Unicode Character Database"
  homepage "https://wiki.gnome.org/Apps/Gucharmap"
  url "https://gitlab.gnome.org/GNOME/gucharmap/-/archive/15.1.3/gucharmap-15.1.3.tar.bz2"
  sha256 "fb10d40cb990d4cd835a53a4874e39bb69146409db46a62d03543c1915eec984"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "937c7b65fa87ab5f513f85abb5c68960c517e9ef6f3da8b1c581b4a4fe27382a"
    sha256 arm64_ventura:  "ee7e34c415afbda101e1784014aaa38985caa7fae057261350e4b77e09085b38"
    sha256 arm64_monterey: "c1c2b25d5a17eeade8d045c04c2575fcfeeb17baab7bd348e2d01224d5834f91"
    sha256 sonoma:         "fda688f5f05e15017b40e886fdc76576da5a7c61c09dca1e913bb23cbf4dc99d"
    sha256 ventura:        "afe4c96b04b6cff057aa6aba089f0b42e06bf4de8747a35efb9f7ad75acfb8b6"
    sha256 monterey:       "75d634ccc137cc07feac07f7a9e37d1cbcf8d982c4f5a429a6b65561de3393ed"
    sha256 x86_64_linux:   "29690eb9d8b42c02ae8b8505a6fb62bf98a3ae52cb47f9c6606e004f4d4881de"
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
