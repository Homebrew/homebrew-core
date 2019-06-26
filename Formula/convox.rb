class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190626154903.tar.gz"
  sha256 "e7f514472b051067365c02dabba7328683288f560c7ba90f2e8cc6f4f5591e49"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8cda8a565460c102e19dc2e8bae9468615b81f85c5ec4b73cfa3e5229e8fd1e" => :mojave
    sha256 "a4c01a25b08e76cd3ef875faf553bc33c5c173364f4290b7ec42512a878e12df" => :high_sierra
    sha256 "4bad6193dc1e0e002961881bc51b038468f33327e34b75072f9b796b4419c4c9" => :sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/convox/rack").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }
    cd buildpath/"src/github.com/convox/rack" do
      system buildpath/"bin/packr"
    end

    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
