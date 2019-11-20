class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191120120724.tar.gz"
  sha256 "8075276ef9767c02ebe21b755e35260c581e7c8da574b712bc81b6dc10d66f27"

  bottle do
    cellar :any_skip_relocation
    sha256 "12996924357ddff5f996d443205d60988418b896afab81a953c43fb363a71ab4" => :catalina
    sha256 "a74e44c98f5c75b3a5205e53463fa9c2204e367487f7551287789213ec56d979" => :mojave
    sha256 "29b1c008d8ac591ce4724b8c871bdd2f0dcbbe69d32b59c48cdf6820024d49ce" => :high_sierra
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
