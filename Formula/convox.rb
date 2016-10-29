class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20161026221456.tar.gz"
  sha256 "6df72ebda64280ef78fbd291b503f48ff015d59c152b4b3bc1b8cb77fcd7a3d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b08c3bb3de8b1c007c24835af15c38bbdb5d175e75fb431d0cc2d3fd39e047a6" => :sierra
    sha256 "dea5d1e416f12dd064baab6ab116bb2d22505b84c22ac88503012b71583d0fc1" => :el_capitan
    sha256 "4ada794fe71c30a25627e36d5f85e60a3e75f7f37bc04f12879d7eb9f2205dc1" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
