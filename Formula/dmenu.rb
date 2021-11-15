class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.0.tar.gz"
  sha256 "fe18e142c4dbcf71ba5757dbbdea93b1c67d58fc206fc116664f4336deef6ed3"
  license "MIT"
  revision 1
  head "https://git.suckless.org/dmenu/", using: :git

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "85b7fd3740477dda3c7e03f71bab77d9e85c2b2dbaf867c17d525d4703a02106"
    sha256 cellar: :any, arm64_big_sur:  "8a7740f82ecab5606dfe3b9fccf6924e4fd00b76d9aa0efacca839279b470edb"
    sha256 cellar: :any, monterey:       "36d4357efb9a6243b9856a89871b3fed7ea6a75bcab1dc420c428e18966d2e56"
    sha256 cellar: :any, big_sur:        "1512aa45817b4bdb25a1190ea923e5454f6c4f08feece65b48b1c05bc75cd1db"
    sha256 cellar: :any, catalina:       "d92a894ca1d4bb9904b4671f7c849738e266a0cd99d28fcd49324edfd888b367"
    sha256 cellar: :any, mojave:         "e08e8de333a1d00b6ba7c94f6d3916bce646cbf651cd04eb1cdd604df49639c8"
    sha256 cellar: :any, high_sierra:    "e94b31e21d9ea3d307b61661fa766592a0856ab13111f17be9a4ae4227759a01"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
