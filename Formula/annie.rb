class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.5.tar.gz"
  sha256 "bf74a5e626ec0319fea990fc5665a2710232c069b8fcbc5ea136433076eade57"

  bottle do
    cellar :any_skip_relocation
    sha256 "2995748c465c0eb0ade104d7c11d7079eede904821d73cbcdc1d7ca0f96e8f1f" => :high_sierra
    sha256 "5cfb0f7f4a10d0e951b08849f463e2cefa4e41b06a0c3ec364c181e3a3ff492d" => :sierra
    sha256 "fe41a09a650e9f392dcbeb15d87a396569e048b5ee67cc05e36b3da980692aab" => :el_capitan
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
