class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.3.tar.gz"
  sha256 "f0ffaa33e93299b38058c507da2945976a4b350c92cf1c4b3649586444395dfd"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "468b3594ae1d102d663432a369331d81eeca703dcfd70a14072f3e49f24c9bef"
    sha256 cellar: :any, arm64_sequoia: "d85acda6fe4b1fc44f8020872ac9409e67ee11a27bbca9e3651a1d0f966cf8df"
    sha256 cellar: :any, arm64_sonoma:  "ce3007de6aa4dbf43026e822b50a8ce72f5ce693e9f005ff0567ad583ca554d7"
    sha256 cellar: :any, sonoma:        "51811ce51d7da81da8717d8c783b084a8ecc5402770e7ec5386dc4b1ebb777ae"
    sha256 cellar: :any, arm64_linux:   "c4d9392350280fa7d36e847e4a36514a98e5bdfa220939fb5b02a4c2c80d1fe7"
    sha256 cellar: :any, x86_64_linux:  "39571e9ceaf4515ae9c1724717ba738dc2e6d5ac0f34a44b239fae7cf0ad60fa"
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
