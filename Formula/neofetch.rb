class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/2.0.tar.gz"
  sha256 "27c208311d5aef8031987b689e3ba3f7663e5487273fa05698132a10a6ef4a48"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "406ebb3eebda7517b496eb896df66966bf974adf2a603358469c01deda9a5238" => :sierra
    sha256 "406ebb3eebda7517b496eb896df66966bf974adf2a603358469c01deda9a5238" => :el_capitan
    sha256 "406ebb3eebda7517b496eb896df66966bf974adf2a603358469c01deda9a5238" => :yosemite
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--test", "--config off"
  end
end
