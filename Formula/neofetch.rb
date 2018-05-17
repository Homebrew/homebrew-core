class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/4.0.0.tar.gz"
  sha256 "b2dae233007ac7d5717df7b1f8f742aebcb84289d5a048398eab3566a8204278"
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
