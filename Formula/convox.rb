class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20181105174702.tar.gz"
  sha256 "391d9266b8a4e334da8efdc132d930f73009d0cf12e7d30abd301959fb34a873"

  bottle do
    cellar :any_skip_relocation
    sha256 "103954666305d46a2879125bc77518d30994067e915d55097f34b1879e8acb62" => :mojave
    sha256 "2296208bba221aa11738b1360d64b8e2c428d3e671ba272b49a8dd92efb9e08c" => :high_sierra
    sha256 "bfa0b9f5c1eebc2e6fa62507104a8145f82c14a5be9923c32c38fe3625b94f7e" => :sierra
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
