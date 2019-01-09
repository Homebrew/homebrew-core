class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/6.0.0.tar.gz"
  sha256 "264a7689561bb498f97f10231959bdd8f7c873671bac2ffb660de9a5863b1c76"
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
