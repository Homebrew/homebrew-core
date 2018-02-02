class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.4.4.tar.gz"
  sha256 "c464a63ca7cc16eef7c14036fe09823ca9d96a0ef530e274845044a5440e47d2"
  revision 1
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "5519d07b34a5056ece68746b2592c2075f0faba70a8d04e1a89e2ad7784c01b6" => :high_sierra
    sha256 "bfaa54f69e164d81d88de6d1fb3773e856238e888a7ac29c13d8dd079827d8f2" => :sierra
    sha256 "4863009cde422f20c4a91e9c0d171b88c26862f0f23cb43257e9a7a0cb71cf80" => :el_capitan
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
