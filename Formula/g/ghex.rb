class Ghex < Formula
  desc "GNOME hex editor"
  homepage "https://wiki.gnome.org/Apps/Ghex"
  url "https://download.gnome.org/sources/ghex/50/ghex-50.3.tar.xz"
  sha256 "30c9ebca3b0e83856e664d13cf6554c0a8beaf7e394268cbb5369434b0f7529a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "3c3b4213094daa429d0c6512809509b36dcf5db16fb37993819fe9ca4922ceca"
    sha256 arm64_sequoia: "5539cded9d878d4fc36543dd86ecb9c8af770f64f39237b801e669cf0ef9802f"
    sha256 arm64_sonoma:  "711ac4eb393f5fd8f7e9f5eebaed910ca46b44f23d51802266044d3c7c136ce2"
    sha256 sonoma:        "799322a011903981cef8aefdf9edad1034bd635ba17cec4c7259328e8352b5d8"
    sha256 arm64_linux:   "9fd3b9872aababdd5a008cb1d79630b02b29be12927ca8e6ed77ab67c15447a9"
    sha256 x86_64_linux:  "bbffa19cf3554409e8b3ceee74224f15cfa11b2b6ef4f1cae4c0b5e7e8e4d23b"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build # for msgfmt
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    args = %W[
      -Dmmap-buffer-backend=#{OS.linux?}
      -Ddirect-buffer-backend=#{OS.linux?}
    ]

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    system bin/"ghex", "--help"
  end
end
