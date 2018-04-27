class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.6.9.tar.gz"
  sha256 "46f6933b044052986b133cbc98789cf3fddcc87c8334cc9aff53e662189f9f2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ce331bcd5cc5181b63e7f875c28ebd98cda97110a6d14d98233b3d0c0936f2e3" => :high_sierra
    sha256 "6fb6cc7648e7f975fd0a8887b6277f707f93f4bd64239e781eb564eadf7d34db" => :sierra
    sha256 "44d7c1a200478c4ae37e71e42581c75e22294b7e5da2de7044ee8d84f2202ab6" => :el_capitan
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
