class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190130162938.tar.gz"
  sha256 "7952de1483630c467b20d06532be43d4224ce26a92e932bf666db141ee80fa0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab847fd367252d30384432738db19c40e14f59f389ad1b746fe3cc2e1d08ffe7" => :mojave
    sha256 "0dcf95cc51ee5754ccfe262ef47befe028c6f883e3a9be1d9251c00641806b0f" => :high_sierra
    sha256 "31e4b5c5f9e58714303f7db823d106f54051728728e2c7f44b0ce787fb636764" => :sierra
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
