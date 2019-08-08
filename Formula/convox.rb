class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190808190811.tar.gz"
  sha256 "f2c6f4dadea44dd79714e4e8d34993a7010607c4cd3284f5ae23d10014ffaead"

  bottle do
    cellar :any_skip_relocation
    sha256 "b93995446e589d8fba8ac58dfdc3623aee607d937d908fa4042ca90f176b4404" => :mojave
    sha256 "8caae544a7cc36ae87db8db21b57ae22875e1ec38d48019ecde105e89cbdc06b" => :high_sierra
    sha256 "de38ebfbc5729a34bb90df697c76ba12508397977357d79588640710d6b0f647" => :sierra
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
