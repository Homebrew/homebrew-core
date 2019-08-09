class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.6.2.tar.gz"
  sha256 "d39fd064b7b34e351e309de6297342c21dcc6caf60e22804f888c7c1f905498e"
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
