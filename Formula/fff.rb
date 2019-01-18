class Fff < Formula
  desc "Fast file-manager (written in bash)"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/1.4.tar.gz"
  sha256 "1a9d0f2ca1920d0ade41c91f27ca5af0f114b35d438cf67b87d8bfb6f6453bda"

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
