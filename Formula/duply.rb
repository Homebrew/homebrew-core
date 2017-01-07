class Duply < Formula
  desc "Frontend to the duplicity backup system"
  homepage "http://duply.net"
  url "https://downloads.sourceforge.net/project/ftplicity/duply%20%28simple%20duplicity%29/2.0.x/duply_2.0.1.tgz"
  sha256 "9d2baf55ada5ab36a6da3fa909c8bdc4ce9a0116eac259ebba0efe9b93180bb0"

  bottle :unneeded

  depends_on "duplicity"

  def install
    bin.install "duply"
  end

  test do
    system "#{bin}/duply", "-v"
  end
end
