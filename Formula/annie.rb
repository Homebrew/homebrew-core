class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.9.tar.gz"
  sha256 "eaa0d0a8c195517bb94684e55aafa343cf182afe0bc61a5b5e4cad7cf8d33241"

  bottle do
    cellar :any_skip_relocation
    sha256 "89a35de388e27f43e72dc33a9c8da4f8a686b8c9b38982e4ad5470bdb36057ce" => :high_sierra
    sha256 "d7e240e40c4df9016c0da6d51122bcdf75bfaf60c46eef2c8153b3a47e10894a" => :sierra
    sha256 "9f25b2bf622161e0070292b6732206c7700929ff4c346e2e0249107deaffc7f7" => :el_capitan
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
