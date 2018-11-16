class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20181110123948.tar.gz"
  sha256 "aaff22d2c8b1e7db4520d5ec7d30fbf90b7b7910f4511a2f7697b6e5400e0560"

  bottle do
    cellar :any_skip_relocation
    sha256 "755c8d9d88fb3ecf6ae90b7620d09711cd019c7712f3e7d33add1d07dfaa31c1" => :mojave
    sha256 "19f0c44393f7dd257e4db63576ab2a02458e8cd51811cc7b7564535454587565" => :high_sierra
    sha256 "85ea26a95e9d07c6a436ec3d2a53837955c6b8dd9864ec29c21a4a05605ba1f0" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
