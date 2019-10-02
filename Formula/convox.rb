class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191001204055.tar.gz"
  sha256 "05d33857621a209aed742d625789ca42f6a4b3e9508c6c0186bd6f3f07486288"

  bottle do
    cellar :any_skip_relocation
    sha256 "8880f721675adf64e581f7a8167d07acdde049b12684fedd2be4c606728274a5" => :catalina
    sha256 "444d6311029a7bf3b93adea3cfd113ab34e708f72b1c75cefc563cf9a64ec679" => :mojave
    sha256 "c3103fffd95988ad3fb74c48d9eb479595d87febb81d5567b82e53c7ca8c5769" => :high_sierra
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
