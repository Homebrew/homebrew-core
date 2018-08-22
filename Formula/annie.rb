class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.16.tar.gz"
  sha256 "623e27d57d1e982a8a54eb6bf66ef14af6d5077f7b7ef773929af3d08ddb1ba6"

  bottle do
    cellar :any_skip_relocation
    sha256 "af58a7694625e8b13d0a51338af4f6926185423b3adc6d6da517f3a850039e9f" => :mojave
    sha256 "c61cdf0eaba8a2f6a166757c3e04344cbecb86da43c7773782dc6440904118c4" => :high_sierra
    sha256 "6ed1662f0c85a009cd08d0bae0daf8bc3d4e6010a2f3d23866e6d1551bcf97d6" => :sierra
    sha256 "d26931e0bb4485f0c828099a0c9e0d1d97add0f5e43f7a462e0fed1cf1ca2755" => :el_capitan
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
