class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170306140228.tar.gz"
  sha256 "7378d4712590f4de967012791bff6a291a4b2a5472ec88d17d7af5a1581d9af1"

  bottle do
    cellar :any_skip_relocation
    sha256 "44ff70c76e85a54df4c64e2d580c2832db47c9e9a911b074b055551e09b29a10" => :sierra
    sha256 "6bd1a1fd374bda7db771c9455050c14d7e519c7dc87b096acd2902e78c8f5d81" => :el_capitan
    sha256 "5f84f54f36202d7ccd3f8a0f22c137fefe8affb63132005cac4765bf596a2a37" => :yosemite
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
