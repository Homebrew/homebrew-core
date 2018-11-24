class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.8.5.tar.gz"
  sha256 "0fa9b0c4c59f0a67d84bef8ecfbd93ec755e7e50945edc6dd877385545d6d8ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "78f86c1e949f2f19f09d7f1898695a96e2f18b77724514562396a3c90588d54b" => :mojave
    sha256 "19f399b3ad405e02e8f74cde72d1a0cc0489de76f5ed6fe188193acbc96a2999" => :high_sierra
    sha256 "5f64823d027b16466f052ed2a01d8e4abd832527ead581d240fd945e5f63eb33" => :sierra
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
