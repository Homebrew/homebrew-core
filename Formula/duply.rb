class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.0.x/duply_2.0.3.tgz"
  sha256 "34b4c544a92faf190c29cbc9eda5f1420ae1550fc7e0a33126a1775d3187b9e1"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
