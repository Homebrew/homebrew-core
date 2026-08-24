class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.3.tar.gz"
  sha256 "f0ffaa33e93299b38058c507da2945976a4b350c92cf1c4b3649586444395dfd"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c1df3a4623ad1f39c302e97ff22d88a3c4ee4c98641e25d59ec3a1e3c97f858"
    sha256 cellar: :any, arm64_sequoia: "500fd3c313b7e428f7bcb1c9424dd3edb688dc9e633fe3943c381b792b156233"
    sha256 cellar: :any, arm64_sonoma:  "ff9762e35b101bdbd42ccbe6fe24f6c5da0bcaba7455d9c7cdfb8818b5c7a892"
    sha256 cellar: :any, sonoma:        "6f22417b27286564c9137a0179045c255ce6cd6dc44ffb976e0b2a81818e5757"
    sha256 cellar: :any, arm64_linux:   "cd70a0a3739c88cc4dae3f745ee45e665713b5204082559908d829652306fb19"
    sha256 cellar: :any, x86_64_linux:  "b7b23f76cd4f8dc2b07feccfb7441831e28089d143153e8ddae28a064cbd6d8e"
  end

  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "pango"
  depends_on "poppler"
  depends_on "webp"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libtiff"
    depends_on "libx11"
  end

  def install
    args = *std_configure_args.reject { |s| s["--disable-debug"]|| s["--disable-dependency-tracking"] }
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
