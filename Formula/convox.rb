class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190918145319.tar.gz"
  sha256 "579b531a63d26bc445388a5bebcaf8774201c85df345153426d626d17351b487"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed935e3c5836517eeb79ac879a0648b4b6e5d359cf5cc41dc50cf0ece4a01786" => :mojave
    sha256 "36e61cafda1d8a77d248da6fe4bb08d2b8d738d1227b0d4ae90332739913776a" => :high_sierra
    sha256 "b263f60f429b4135d50e1aa2d7c0a342e302a1dbc5a052d97babc89584a547f8" => :sierra
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
