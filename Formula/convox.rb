class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170913220722.tar.gz"
  sha256 "982a6a863c1bf4db9e3d96d5cab0347512583947cdbdee04c5a6c7dbab67fcea"

  bottle do
    cellar :any_skip_relocation
    sha256 "b3a826209250c88adcc1e134b412055606843e27f674be47d20159e66359be41" => :sierra
    sha256 "ef60546659ae7851823870e5ebbe65de2f7040e9a0cb1f526da227bb14441d8f" => :el_capitan
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
