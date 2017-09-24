class Neofetch < Formula
  desc "Fast, highly customisable system info script"
  homepage "https://github.com/dylanaraps/neofetch"
  url "https://github.com/dylanaraps/neofetch/archive/3.3.0.tar.gz"
  sha256 "4808e76bd81da3602cb5be7e01dfed8223b1109e2792755dd0d54126014ee696"
  head "https://github.com/dylanaraps/neofetch.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b415a5e617cfbebac3d6e5d585a8306eb3fed1bd22c6b1a7088f623a3ffec173" => :high_sierra
    sha256 "9ee6ce5a7c1542275dddc52a5f108e86e64c021364d3639ce4ed7ee987a01cf5" => :sierra
    sha256 "9ee6ce5a7c1542275dddc52a5f108e86e64c021364d3639ce4ed7ee987a01cf5" => :el_capitan
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
