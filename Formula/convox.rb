class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170920223951.tar.gz"
  sha256 "15b05e3d4cfdf304e169d163dee1673af05fc6753d50ad8b022fd28f24d0a3dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e398fc3b0585a3091fcb62dc49c3b829ed61e87c595941df27d0694bad4da79" => :sierra
    sha256 "0541aa043e77c10b1525ac673600739c3b04dcd6e1132f6e453bc1270008d5c3" => :el_capitan
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
