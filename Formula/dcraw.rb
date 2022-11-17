class Dcraw < Formula
  desc "Digital camera RAW photo decoding software"
  homepage "https://www.dechifro.org/dcraw/"
  url "https://www.dechifro.org/dcraw/archive/dcraw-9.28.0.tar.gz"
  mirror "https://mirrorservice.org/sites/distfiles.macports.org/dcraw/dcraw-9.28.0.tar.gz"
  sha256 "2890c3da2642cd44c5f3bfed2c9b2c1db83da5cec09cc17e0fa72e17541fb4b9"
  revision 2

  livecheck do
    url "https://distfiles.macports.org/dcraw/"
    regex(/href=.*?dcraw[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "67ed6c9b0e400aad488b5449b439c3d2c2f1367ec855d95c2cedf1eddf0ab9fa"
    sha256 cellar: :any,                 arm64_monterey: "3d77794768e6ae2d0ff3ffbacc3ed745017f7ffc2503da954100b2d1ac146db7"
    sha256 cellar: :any,                 arm64_big_sur:  "899ea09ca46695dcbae2414fd72f3af86fc8676e0e51aea2b54baa28a4a5845d"
    sha256 cellar: :any,                 ventura:        "8e605ef084d83242cee08c32354896073428b53be4f2bcd0ebc855da98b8325a"
    sha256 cellar: :any,                 monterey:       "72c6183da24a08d3cc0d887ac294a51c14d5b39c8b2a42820cc4a4351768b9b1"
    sha256 cellar: :any,                 big_sur:        "2f5f80cfc1599bbc5615312a1652f6904e3ef79d24d30c68e3d6e7c185d517ce"
    sha256 cellar: :any,                 catalina:       "6ad0be7cd49f7ccb34d7159e2a78e231be474cf32d094c722aaae6e4e354c65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97498f11a22904605edaa7fce8b823bb7f93cf6cd336e3ab9fb0e9811a892426"
  end

  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "little-cms2"

  def install
    ENV.append "LDLIBS", "-lm -ljpeg -llcms2 -ljasper"
    system "make", "dcraw"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end

  test do
    assert_match "\"dcraw\" v9", shell_output("#{bin}/dcraw", 1)
  end
end
