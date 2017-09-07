class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.4.2.tar.gz"
  sha256 "3d4ee113d4c7918ad3c660f8088473d5fabf67b3476fef16ec7f5bd8a4182fdc"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "1edb9cb7db180ea63fcf851ae4650d3609ee4e34ec2ce085231b9302574624e3" => :sierra
    sha256 "946aaf7502edaa5ed94fb260157ae80c6becbc4ec6c598ecef9dbb16da22d657" => :el_capitan
    sha256 "6a90cc517ad8685c28223c978faf8b37745c70fc4c0e4f19b0c5c094054e62e3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libzip"
  depends_on :osxfuse

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
