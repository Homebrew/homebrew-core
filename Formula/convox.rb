class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191211175055.tar.gz"
  sha256 "3af04e2d968e614519f1a4b0d2d88f20d7f157138ade3058aee9717178c80f62"

  bottle do
    cellar :any_skip_relocation
    sha256 "4190cfdd4febc5613c84b82c0f333677d16cb155a8b87c5311107eedee35358b" => :catalina
    sha256 "42f694eb99bc9b1655117bc4935f5ec18607452df66b96f96ae8feac43bc2ac5" => :mojave
    sha256 "62769076502edce8320b483dcc54b2339b206cf0536393ff8cfc3bc8001545c6" => :high_sierra
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
