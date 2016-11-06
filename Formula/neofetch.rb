class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.9.1.tar.gz"
  sha256 "d7e30215994968ca861836f9bab9259624688fd50620e7d5af5c8b31da8bd32b"
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
