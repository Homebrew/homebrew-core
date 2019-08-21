class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.5.tar.gz"
  sha256 "69e0213c81b88838c01f93eb00ce68701ad36ba53301327965acb7a6b39bcc3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5176c32457d725bf14ccb0d36e570996db4571428cc21a8f562bf938c86e17e" => :mojave
    sha256 "d532d4c449e12039bbe0d4f539f96b8a0b7d77c5bc2615c620b627ffafa265bf" => :high_sierra
    sha256 "baa97a5223e66e67786dbd786df0c75467393fdff9df0594e57a084097d9e7b6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/iawia002/annie").install buildpath.children
    cd "src/github.com/iawia002/annie" do
      system "go", "build", "-o", bin/"annie"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
