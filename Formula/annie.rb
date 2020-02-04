class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.8.tar.gz"
  sha256 "49bad7855cfacde8c55cf7d2c5bb8b5e5bf6d8853a414e5c5ca6447d9f7be3ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "936df600e5e26a50067560b3f2e1ab6fa74f3299d22a1e71cb084362d6328dd3" => :catalina
    sha256 "a2d84f9da8d6a2e8b37c8abe2d7d5bdac93124a44d71f664a50fc97a1b2d1c26" => :mojave
    sha256 "20bde6a585020370347508c19c0a3991ac873c60cda40feba1bb2b528388a372" => :high_sierra
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
