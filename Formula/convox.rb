class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170413140500.tar.gz"
  sha256 "44de1654c5ea97e10314e16f84c7430537a5a2c65bb0237ba7f4dfb6094d3db5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b90826e96ec7f19d2d348921d06e375ccc4a505d01fdd19339697d3971a6717" => :sierra
    sha256 "4a90eba5d7dc37394d21a4ae070c27d9adf70a27305195267978dca561a7782a" => :el_capitan
    sha256 "7256687585d0f0ff6e347f1455b95a8a603b261ce25f07587c844f46c4206cd4" => :yosemite
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
