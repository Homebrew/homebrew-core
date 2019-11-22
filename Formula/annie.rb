class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.6.tar.gz"
  sha256 "e5e505ff7c7363fed6dbeed7ccefb3af726312ae19fd290b3179f5d41cb63d22"

  bottle do
    cellar :any_skip_relocation
    sha256 "6560d04f09c28d7cb8b5013eb62a569e30eb59462375f30575b15f73cd6b9171" => :catalina
    sha256 "3897252d4dcd0f100215ce986dee661b2caae620690b5db9237a8fe64b8e02e3" => :mojave
    sha256 "a00211a682f61543f119bf5c5c1a8c540e88318ba42b82f815179be941a34d1c" => :high_sierra
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
