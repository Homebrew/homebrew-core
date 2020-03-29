class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20200302115619.tar.gz"
  sha256 "850c2e468273bb2b9b42a144b97477d777e31c1554ab514606072c3cf64b3536"

  bottle do
    cellar :any_skip_relocation
    sha256 "d14ea503227afd3e9d282da425cdbf05a0f6ffcd35b64e32ac8c0eae811015dd" => :catalina
    sha256 "1dda147d1c038555e10980ae23a89ef9c639827420c9a1b4645992d5786ac893" => :mojave
    sha256 "20bd6147a0bff746304784a96539aaa06cb5458ddfe41990d5be68b7c759f93a" => :high_sierra
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
