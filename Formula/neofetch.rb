class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/5.0.0.tar.gz"
  sha256 "2a4f4853bf83b88a037994dbc53a90c8bd5708f5eeb3392f56d4e49c49d995b3"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c119a528c4d573c284c42512d3e6ef6bf781c05b730c608150998dc92b9eb099" => :mojave
    sha256 "f87e12ccbe4ef1de1757f4f0d2f03c4aebee3db21d0f27cb2e54451f572f3836" => :high_sierra
    sha256 "f87e12ccbe4ef1de1757f4f0d2f03c4aebee3db21d0f27cb2e54451f572f3836" => :sierra
    sha256 "f87e12ccbe4ef1de1757f4f0d2f03c4aebee3db21d0f27cb2e54451f572f3836" => :el_capitan
  end

  depends_on "imagemagick"
  depends_on "screenresolution"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
