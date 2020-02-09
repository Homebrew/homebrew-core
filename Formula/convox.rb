class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20200129210159.tar.gz"
  sha256 "945d6237ea0108ef0cd5ab9e6dae0f898710ca84a65d8480b8466e4c40ff99af"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5c1f84d8cc89e4c987cfdab0561f3bafa905e80b36f09c120aad268584d88dd" => :catalina
    sha256 "ddd30924728c622584889bb4e65323ca07b6dd818b74ab37df4283965449c850" => :mojave
    sha256 "8c75cf941a1cebcb655670d093b9d102be96ccc4d3df45c4a8c312d2bf085020" => :high_sierra
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
