class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.6/gcab-1.6.tar.xz"
  sha256 "2f0c9615577c4126909e251f9de0626c3ee7a152376c15b5544df10fc87e560b"
  license "LGPL-2.1-or-later"

  # We use a common regex because gcab doesn't use GNOME's "even-numbered minor
  # is stable" version scheme.
  livecheck do
    url :stable
    regex(/gcab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "c75545ed9d16ec696c778a2d77108ad14afbf285827ca9ddcfeeae4c484b5b37"
    sha256 arm64_sequoia: "62b5353419de06fbadf4cd171f811b8f851a44e708536846c8aa3a13bf5f7e45"
    sha256 arm64_sonoma:  "8d5158d23c33bf53bea21deec58a4cc8fc0f9bdfa0850c7c90528077cacc16a1"
    sha256 sonoma:        "b261ee3be1c5500cfb83e60deca5437314876de92c530190c6b060ba2d343bf7"
    sha256 arm64_linux:   "8e6a3faf289fab7e33a2aaa9fc70935cbf090eb2bae3fb4d18eea215c0fc92ab"
    sha256 x86_64_linux:  "cb73b8bf3a8fdc8f01c932e3720ae79cbb00c05721698e562c0f08add0bfc7ee"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build
  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"gcab", "--version"
  end
end
