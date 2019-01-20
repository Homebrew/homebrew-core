class ElementaryWallpapers < Formula
  desc "Collection of wallpapers for elementary OS"
  homepage "https://elementary.io/"
  url "https://github.com/elementary/wallpapers/archive/5.3.tar.gz"
  sha256 "a8383821f2d3877ca172d49d711f90e7ddcf6f254469703cec90cb5bae70c383"
  head "https://github.com/elementary/wallpapers.git"

  bottle :unneeded

  def install
    Dir["*.jpg"].each do |bg|
      (share/"backgrounds").install bg
    end
  end

  test do
    Dir["#{(share/"backgrounds")}/*.jpg"].any?
  end
end
