class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://code.google.com/p/fuse-zip/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fuse-zip/fuse-zip-0.4.0.tar.gz"
  sha256 "db9eb13aa250061eaa7df6b1ee5022dbea54089094af94cc3d1767b63bdc9ca7"
  revision 1

  head "https://code.google.com/p/fuse-zip/", :using => :hg

  bottle do
    cellar :any
    sha256 "42b7f614872bb6d904a270cdda17b6cf28cd2b343e83278418b39d885607913e" => :sierra
    sha256 "698ece5594c8279baedbb205bca7be8508b36e48ae10a8a7ab3aaf13a806712b" => :el_capitan
    sha256 "6be1b2a0977ee4367ec6d84eee84268226e3a914a9509a9de12aff080642f813" => :yosemite
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
