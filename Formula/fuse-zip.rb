class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.7.1.tar.gz"
  sha256 "7dac61c3f27f9041545ab1a22bb772ea282ed2dea25a0220dcecfa6801b5b121"
  license "GPL-3.0"
  head "https://bitbucket.org/agalanin/fuse-zip", using: :hg

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "570b1b88d586360f0be52dd67de67d5e7232c9aee1734d3d19ca11092af12aa1" => :catalina
    sha256 "d02e3b4695535794d1c6dfceedf3db3b3eaffa5181bd23b9ec7c9e047761a055" => :mojave
    sha256 "dd165964a99e12206f15bf33a5032fc5e440c27a04ab77cd1c36bf2efce64b19" => :high_sierra
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
