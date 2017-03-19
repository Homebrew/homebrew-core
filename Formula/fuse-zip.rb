class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://code.google.com/p/fuse-zip/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/fuse-zip/fuse-zip-0.4.0.tar.gz"
  sha256 "db9eb13aa250061eaa7df6b1ee5022dbea54089094af94cc3d1767b63bdc9ca7"
  revision 1

  head "https://code.google.com/p/fuse-zip/", :using => :hg

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
