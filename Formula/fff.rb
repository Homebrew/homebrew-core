class Fff < Formula
  desc "fucking fast file-manager (written in bash)"
  homepage "https://github.com/dylanaraps/fff"
  url "https://github.com/dylanaraps/fff/archive/1.2.tar.gz"
  sha256 "a77095950c2fe1eca82c12c41273ed987e295e522c7e85365192f9056e4f80d8"

  def install
    bin.install "fff"
    man1.install "fff.1"
  end

  test do
    system bin/"fff", "-v"
  end
end
