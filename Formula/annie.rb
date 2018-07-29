class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.7.12.tar.gz"
  sha256 "285645cacc392e05d750d817f4989ec233e21e11716412b478862a2ba8a00a83"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecd57c4f33688c6178b88e737718b9ad5711a351dc1ddb6946458ed852ba3f3e" => :high_sierra
    sha256 "5677c8140c5c2e1718f80b0038fd468b5fb852faed798f4c6cf5468d89bac841" => :sierra
    sha256 "5a665e4971515a5679854c4bac3a0c002fbed394e479dcc2dbf2e01cd714fbd9" => :el_capitan
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
