class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.2.tar.gz"
  sha256 "075439747b1641683bd2d9a8d7d7e3d1ad916417576ccb4b89d01cfd73a0fcc6"

  bottle do
    cellar :any_skip_relocation
    sha256 "5607e622d89a1da816cf9fe36951311105feab25fd2248a56a9a4ebb5fc0caf8" => :mojave
    sha256 "bc0472c4c1e500d25c17d85fc85808b8318cba113cd4b29ed6ef66516847287b" => :high_sierra
    sha256 "0c467103a7530fba62687800e8269167f9dfa262e92c7b2914551d987ff8ba08" => :sierra
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
