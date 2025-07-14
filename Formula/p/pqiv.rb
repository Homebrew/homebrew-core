class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.2.tar.gz"
  sha256 "154cbbe0a62be12cee23b0a46a86b2305d8128fd19924308ad5e9d22fa5ad4f7"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e44986d59fbbfadb05ec2d40c769eb87deac34da0a21291a3ad933dd30af109c"
    sha256 cellar: :any,                 arm64_sonoma:  "021459c868cb76745936d836395a26210307ad99b7145f4ad365eb18c97fc9a1"
    sha256 cellar: :any,                 arm64_ventura: "c0d57afe7ac1a17e4e3430fe0e07ebb6edafca503f2725f49ba9942e553f7a77"
    sha256 cellar: :any,                 sonoma:        "ca0cb5916c301360054b74d1ce2732273fce60f3b03d96b0fb9ca774f6bff32e"
    sha256 cellar: :any,                 ventura:       "4e7dbe5ea248fd4bd10c0fec39ac71680cab1a019b7501a3d8b3a28a9f9b89ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fa5bfd357ec838bc9611ebfcd5e8cb8d6b769b1393e8d8e46d89b8947f714e48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ad555fc865b2af09114d0e8132435f9b166696bfdc8ed588e26b19cb5531f99"
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
