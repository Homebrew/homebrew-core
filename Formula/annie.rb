class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.1.tar.gz"
  sha256 "20b43ceb46663513b164cb581ddae4276ee9b371f122e52ae4baef65c56e4a3b"

  bottle do
    cellar :any_skip_relocation
    sha256 "08430620b0134fe90414529f481cefbf5ecb607126e0120722f648a49e798ed1" => :mojave
    sha256 "fe01b8283c50f3e5198aa3f185eac10ae2fe668a358ec1e01c0016d6d0d89aba" => :high_sierra
    sha256 "5a21d5922090baea34ba726162e4db7bc3fb9d35cc4386baa1fda5f3d9340924" => :sierra
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
