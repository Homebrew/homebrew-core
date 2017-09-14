class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.3.0.tar.gz"
  sha256 "4808e76bd81da3602cb5be7e01dfed8223b1109e2792755dd0d54126014ee696"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d49fa4d211b258dec4c493e613a558b870d5623fbdb817b2148e5c0a1ff5257" => :high_sierra
    sha256 "360034118a2b6212bfca66d4e182efd4b3e5deab2c4c444cf53e4fba2174e0ec" => :sierra
    sha256 "720ca014c10c3b98e8146b3f2a42358e1e243008a9cca41763b2816611d3abd6" => :el_capitan
    sha256 "720ca014c10c3b98e8146b3f2a42358e1e243008a9cca41763b2816611d3abd6" => :yosemite
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
