class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/7.0.0.tar.gz"
  sha256 "8c6bd217cf6d34fc1f3dcbb0e8b1137655bc13fbb21165273dbb2a7bce0d3130"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d78734c76762358086f2e84b0f44aa6b55f7e7dc1d23e9254d764901a1547c28" => :catalina
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
