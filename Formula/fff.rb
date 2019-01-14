class Fff < Formula
  desc ":rocket: fucking fast file-manager"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/1.0.tar.gz"
  sha256 "6e5eed18b50b3e1a2497092e618665ff00b71b27b4f7653f9693ee40517d1a8a"

  depends_on "bash"
  depends_on "coreutils"

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
