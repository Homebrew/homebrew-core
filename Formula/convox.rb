class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170724235705.tar.gz"
  sha256 "bf3cd3283429051cdb51c3215533920ca172109b06b4e5e51d1f77a66c5e5464"

  bottle do
    cellar :any_skip_relocation
    sha256 "fbebfa096128c16a3a64b76e58c5c6984877a1be799bb17b33eaa4ba0523e750" => :sierra
    sha256 "68c6e2c6f80cd957191cfaa7666d62164c3156b84b38e6840d4bd36e10f2e800" => :el_capitan
    sha256 "e67f0586099195b7a3e3e0670ebdc3ecca8d31aa692d28a5f07c9c1d8d23a116" => :yosemite
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
