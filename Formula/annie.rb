class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.8.tar.gz"
  sha256 "96f77b3a38592011c108a7c73fc1875cd656f462bd0ac6e41e041fd78138ed3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec9b8a353a5f1cac310b67c68582231b5ab4277191f4e4f9bf914339d2968a94" => :high_sierra
    sha256 "c2ad535dcb0901ee5b78f40746dd3d4a05a9a62f49c3d81bbd9c3a4de8fb9d91" => :sierra
    sha256 "13e8c420f75f4d94a97567d82834fd8b093350230cbc4a09c9d70e4f74257eed" => :el_capitan
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
