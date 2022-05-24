class Dvdauthor < Formula
  desc "DVD-authoring toolset"
  homepage "https://dvdauthor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dvdauthor/dvdauthor-0.7.2.tar.gz"
  sha256 "3020a92de9f78eb36f48b6f22d5a001c47107826634a785a62dfcd080f612eb7"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/dvdauthor[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bc83c8e514066eca33c4ba473f833bbd9e39f37dd98f648d0ed826d7e2c0b2f1"
    sha256 cellar: :any,                 arm64_big_sur:  "a0b0c601eb1ec9de60de448cab11217c63febd18afd7a9ee6207fdb1427593f5"
    sha256 cellar: :any,                 monterey:       "1370f3dc33ba0f60e930b946e9eedb0a7eca35ccf87511c0c3dbe6a8f658b1eb"
    sha256 cellar: :any,                 big_sur:        "c6405e471ac402f1b0ec1e2fbbb2ee3eb4be9dd82f0ef5b8991339928ff2fdb0"
    sha256 cellar: :any,                 catalina:       "7ebcd748eb4eba1876bd1cb181fa6ec679773dbf753be805845904b69685ee11"
    sha256 cellar: :any,                 mojave:         "5da2d90859c186ea0795b18210ef2722f96bfbb16f53d3a0cb0aa89084026ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6c257894d2aa40c73cef22caac501ade1681f1b452d1d0f5f1fd23bd34b8df4"
  end

  # Dvdauthor will optionally detect ImageMagick or GraphicsMagick, too.
  # But we don't add either as deps because they are big.

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "libdvdread"
  depends_on "libpng"
  depends_on "libxml2" if MacOS.version <= :el_capitan

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    ENV.deparallelize # Install isn't parallel-safe
    system "make", "install"
  end

  test do
    assert_match "VOBFILE", shell_output("#{bin}/dvdauthor --help 2>&1", 1)
  end
end
