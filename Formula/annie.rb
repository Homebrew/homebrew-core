class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.10.1.tar.gz"
  sha256 "3ad04d789db82a139b1fe914889af5a75fef8eca1e55446b25dae682a43e23e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "79096f64aee8e433ecddcd4b8d139a4d71db50127eae9aad548b06e3ee8d7186" => :catalina
    sha256 "f8efa9dd1d995885b6995409816b8cbb95ab5c0380c439350ae90ae3ce9c6eca" => :mojave
    sha256 "4a102d4e8684a8ffbba3607831ca037821ea9558078d71c613a20338db0fa71e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"annie"
    prefix.install_metafiles
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
