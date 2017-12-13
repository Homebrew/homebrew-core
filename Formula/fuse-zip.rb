class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.4.4.tar.gz"
  sha256 "c464a63ca7cc16eef7c14036fe09823ca9d96a0ef530e274845044a5440e47d2"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "76bda2baea148ceda1a4af12e94686c499a4acd5033dd846a148e07fc49c4b63" => :high_sierra
    sha256 "8f4054cc64b699d8ce29c33cca1e73e05c55e5151ab6eb4c6a8e6e0eb0ae9579" => :sierra
    sha256 "56131c4207a94a518a2a6ebdadeb6db58662b36990c15492fb03cccba89f58aa" => :el_capitan
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
