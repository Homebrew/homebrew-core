class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/2.0.1.tar.gz"
  sha256 "9718c3c11808448dc607954ec375a692daf6a365bbc8b384668f708717f1c0a1"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "585b875470f199c83fb6992d4d07ffb61616a19632db4a9267d4b4caabaaf6e8" => :sierra
    sha256 "585b875470f199c83fb6992d4d07ffb61616a19632db4a9267d4b4caabaaf6e8" => :el_capitan
    sha256 "585b875470f199c83fb6992d4d07ffb61616a19632db4a9267d4b4caabaaf6e8" => :yosemite
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
