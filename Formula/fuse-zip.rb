class FuseZip < Formula
  desc "FUSE file system to create & manipulate ZIP archives"
  homepage "https://bitbucket.org/agalanin/fuse-zip"
  url "https://bitbucket.org/agalanin/fuse-zip/downloads/fuse-zip-0.4.5.tar.gz"
  sha256 "2c5101f5bcb8d666d1ca602717ba901567dad2e7ad7de9db6e5bb26ac57435d1"
  head "https://bitbucket.org/agalanin/fuse-zip", :using => :hg

  bottle do
    cellar :any
    sha256 "6749e24126db7a7ea4cdc6b25684f1a60bd5fc16cc377e625d1d68e9ed17b71b" => :mojave
    sha256 "28d48355db992f6b6ac572633483efd83743e6f2d2de5426425dc10e8e4f9bee" => :high_sierra
    sha256 "08fed5ec5f219ce9c9076451cccf0421c6cb4714af8a4d37eae2652b8ae783f2" => :sierra
    sha256 "98e9d774573f5bb6c2ea887b3eaa84ddcdbb3b07f7d9be6182a219e3383eee7f" => :el_capitan
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
