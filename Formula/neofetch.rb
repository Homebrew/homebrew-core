class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/2.0.2.tar.gz"
  sha256 "25a174ed41720d7645240cce4ca24f6228097a0daae3afd42563bfcf01584bc9"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :sierra
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :el_capitan
    sha256 "eb1cbc74bba6487b48d9c7c6f9118bd49ce0572751f42461f52341d9b0b43f86" => :yosemite
  end

  patch do
    # Fixes image display in iTerm2
    # Will be removed in the next released version
    url "https://github.com/dylanaraps/neofetch/commit/926dea972b82d1b81e5501e63c8d4395ee274b84.patch"
    sha256 "d0132c00c50111de60cc31b07c2dcf07aaba8ce378e1553e3322dce159198155"
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
