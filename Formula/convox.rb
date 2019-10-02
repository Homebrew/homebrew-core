class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191001204055.tar.gz"
  sha256 "05d33857621a209aed742d625789ca42f6a4b3e9508c6c0186bd6f3f07486288"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1a1c50b2b290b3ada7871ab8b18af2f02f55b5f169cdb7c07efcb1e068a5696" => :catalina
    sha256 "215d38747544079f064c4d32757dc2e1248f580680811c67d58682d958822ffe" => :mojave
    sha256 "087470ac0f18cb77a538ddb313fa96ce96b4d0b00be2d193244d42d988c83e18" => :high_sierra
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
