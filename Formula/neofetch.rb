class Neofetch < Formula
  desc "fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/1.9.tar.gz"
  sha256 "c9cbe0eeedbceaf9b23f9a1c4e0838e410dc7bdfdeb7fbd10f5eaf377cceff05"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e644bd964028ee940488bae7d5e0b8d47ec18f97cd84fd4c38431f72e2cc8d9" => :sierra
    sha256 "8e644bd964028ee940488bae7d5e0b8d47ec18f97cd84fd4c38431f72e2cc8d9" => :el_capitan
    sha256 "8e644bd964028ee940488bae7d5e0b8d47ec18f97cd84fd4c38431f72e2cc8d9" => :yosemite
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
