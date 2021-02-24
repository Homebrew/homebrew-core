class Fff < Formula
  desc "Simple file manager written in bash"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/2.2.tar.gz"
  sha256 "45f6e1091986c892ea45e1ac82f2d7f5417cfb343dc569d2625b5980e6bcfb62"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
