class Fff < Formula
  desc "Simple file manager written in bash"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/2.0.tar.gz"
  sha256 "a202bde184724239786ec93ccced8054e9d5788239312ef91d74593469ebb10a"

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
