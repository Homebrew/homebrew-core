class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/6.1.0.tar.gz"
  sha256 "ece351e35286b64d362000d409b27597fcbdcf77e8e60fa0adae1f29d3c29637"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "28101b31f5b5c74332f425dc22819ea272f085b73a7d8aa892daa8c9f12c3baf" => :mojave
    sha256 "28101b31f5b5c74332f425dc22819ea272f085b73a7d8aa892daa8c9f12c3baf" => :high_sierra
    sha256 "4f9522500f193bb660a7a449706417e450a8a217e98b6439c1c7a9deab3e0970" => :sierra
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
