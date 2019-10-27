class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191021163708.tar.gz"
  sha256 "c0917701eb22e550afa7b6bcd64cc2354caf7a602035460208e088373fafa989"

  bottle do
    cellar :any_skip_relocation
    sha256 "0c5399ac116390a3456f848acca99b86caa4bb8e226511fd97ee10816d15fb1f" => :catalina
    sha256 "db18a35f4d808f0971c451a31fa8aba98298b648f0b8b436e33dc2b2af086ebd" => :mojave
    sha256 "cd46ef0ba36da40f1a524754334ac330f39726c0bb0c9fe6156dda4cd7183765" => :high_sierra
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
