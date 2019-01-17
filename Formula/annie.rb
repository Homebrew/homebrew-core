class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.1.tar.gz"
  sha256 "20b43ceb46663513b164cb581ddae4276ee9b371f122e52ae4baef65c56e4a3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "3eca9b8f24169aaf0c72a2bdb371de119cb9f9d5f643baa58c10c38a1d8824d5" => :mojave
    sha256 "7a7aa592cfbb5adb3817ba3747a54670437bbdd12538825a96d3594a140ed96a" => :high_sierra
    sha256 "029a608d1dbdb45319e846ea10f2c2e675f173bc7b1972909e0884a16134898f" => :sierra
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
