class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.10.tar.gz"
  sha256 "0653ea96a092621d3cf884269a0fc75fc767385e50acf9825fda1c4230b4b01b"

  bottle do
    cellar :any_skip_relocation
    sha256 "25a2f20ba454b3ab9ae49f7de5917ab4dacae34e5e179ef36ee3ea94811cac60" => :high_sierra
    sha256 "d03dcb05e8e3dfd51dd6c2c3a232ee966f5c5925b2b9ca022f477a7598849713" => :sierra
    sha256 "aef201163b1dc90a1a654beadd0b138015503a02728ba75232e237ba3d3d7c4a" => :el_capitan
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
