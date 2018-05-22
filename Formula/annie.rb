class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.0.tar.gz"
  sha256 "dab16f51b7722e41cabef333f206a0e46d1a14eeda39b6be0f606c63ae69f930"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef8506c979fa1b1ab3b2d0ade30e35b6873870aab94d5ba9bad14288d4dc60d0" => :high_sierra
    sha256 "bfcc7a9d6168473923606baf6f82dd578f25e6112cf514eb85c8309f73ee54b4" => :sierra
    sha256 "d93f6de6fee1eaca66cb95d0fb32a7287ac067fcf137b4fd3aa22c5b0bade72d" => :el_capitan
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
