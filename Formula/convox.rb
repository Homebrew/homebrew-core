class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170920223951.tar.gz"
  sha256 "15b05e3d4cfdf304e169d163dee1673af05fc6753d50ad8b022fd28f24d0a3dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "77036dca71fa71c6c7095fab82fc6efb2346c24ffaaa6fc759d6d9bc5a403e82" => :sierra
    sha256 "6a7cd8963e56d6d648f347aa9ceafaaf90463e03948b9bcbdec6e4e6a419357b" => :el_capitan
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
