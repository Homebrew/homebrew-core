class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.6.1.tar.gz"
  sha256 "1e6de98f2f586cdc161deea31ac58cb604d6ceb9dbc0a05267c0726166f81965"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "86b8df314e9dabf3e5fe0df1d9d647204799696a9f2f0d9199f94a6536fcaf01" => :mojave
    sha256 "58e531f3bc48fa5d1da367a57dda87fc04538d9f7c8447d88b1d8cc04ab7e74f" => :high_sierra
    sha256 "88b1d9e1c807232718036fbf619df6ddf7e6626ab064db4599d48142410458df" => :sierra
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
