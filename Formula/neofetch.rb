class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.9.tar.gz"
  sha256 "c9cbe0eeedbceaf9b23f9a1c4e0838e410dc7bdfdeb7fbd10f5eaf377cceff05"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :sierra
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :el_capitan
    sha256 "1c5cbcf6dee70c3d9a537cf2ff73cd4d7adffc2267c555c835b448358f9cc76e" => :yosemite
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
