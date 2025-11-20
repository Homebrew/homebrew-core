class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.3.1.tar.gz"
  sha256 "33cc0e25daa62e5ba7091caea3c83a8dc74dc5d7721c4501d349f210c4b3c6d3"
  license "GPL-2.0-only"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "7986e7f825b1b6c2f31beadad835a38e018b215d50ec918a4c943c1449127127"
    sha256 arm64_sequoia:  "7acba4db4f6cd2ad09e1cffff1f7c0d24c46cbc611c8ed9c7e78a604b746b2cf"
    sha256 arm64_sonoma:   "abf6159ff6f8b96053d162b2022ed8609af8c059c79348ae5557c28afeecc562"
    sha256 arm64_ventura:  "3330a2f548559889d4d2cc138d79e5bd39f00aea3c14525912fd5f6c1c20136d"
    sha256 arm64_monterey: "adb21b8016cdf6604a4d2ab0a8231769c08c19eb59f030e45229397f8bb71560"
    sha256 sonoma:         "17172832ac98aded38af454786303dc8f9d3b61e90470a4330a7774ae5885dd4"
    sha256 ventura:        "2049a7ee4bb92a609351d65b0c16adc5bee3f81cdfa580ade205dfcef48d8b4d"
    sha256 monterey:       "e6eb367af3e6e6cd9d08aeb7089bf2842422c9c727df241f11fce7a2239a3d64"
    sha256 arm64_linux:    "855b9f2180841ac05b112906346852effcaf37d1e0ccdfc11b6561f947da4a85"
    sha256 x86_64_linux:   "e69fa72c81515369642531c0e5fc7febe6953d082721eb5b1e839c0f7a72a597"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--disable-unity", *std_configure_args
    chmod "+x", "install-sh"
    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_path_exists bin/"grsync"
  end
end
