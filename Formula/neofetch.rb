class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.4.0.tar.gz"
  sha256 "2b03328e92f80de8aca9571ad693f4e8b86b62e9c99792f3002f82907c5530a3"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a037a66db7d9afe351da7c8f03fc8e0539f37725f624b54dfd3c580fd2c0329" => :high_sierra
    sha256 "0a037a66db7d9afe351da7c8f03fc8e0539f37725f624b54dfd3c580fd2c0329" => :sierra
    sha256 "0a037a66db7d9afe351da7c8f03fc8e0539f37725f624b54dfd3c580fd2c0329" => :el_capitan
  end

  depends_on "screenresolution" => :recommended
  depends_on "imagemagick" => :recommended

  def install
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"
  end

  test do
    system "#{bin}/neofetch", "--config", "none", "--color_blocks", "off",
                              "--disable", "wm", "de", "term", "gpu"
  end
end
