class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://code.google.com/p/fuse-zip/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fuse-zip/fuse-zip-0.4.0.tar.gz"
  sha256 "db9eb13aa250061eaa7df6b1ee5022dbea54089094af94cc3d1767b63bdc9ca7"
  revision 2

  head "https://code.google.com/p/fuse-zip/", :using => :hg

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
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fuse-zip", "--help"
  end
end
