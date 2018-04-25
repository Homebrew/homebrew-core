class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.8.tar.gz"
  sha256 "d87d7fe17a9589c170379dd1558249e9fef753f3da02fbcb684282e8c35420f3"

  bottle do
    cellar :any_skip_relocation
    sha256 "16281818d1b22e95b6636ba85c46d16b60d4d46464aaab71b53de3ce6b785f78" => :high_sierra
    sha256 "2e23e99a48922e032ea4edcc14bd3471152f59f7099774ee372e604ca222ba97" => :sierra
    sha256 "a6845b72b3445a5ab2200db40cacfb668001ba2ec6e787110da8a6c6cb393873" => :el_capitan
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
