class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/1.11.x/duply_1.11.3.tgz"
  sha256 "585757a02abc91bcc0e37004eef735794d6581d1a30ec68303c6c04833b20940"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
