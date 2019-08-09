class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190808190811.tar.gz"
  sha256 "f2c6f4dadea44dd79714e4e8d34993a7010607c4cd3284f5ae23d10014ffaead"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6f8e907a3bf74d07a1cc5c0763a7d91e8c1db8e75ca0b5fb963b1c1eb9a5ca9" => :mojave
    sha256 "3198731aba7624070995b9992e7518f5ea995461c285302fde87d8d609a4a4b1" => :high_sierra
    sha256 "7c0b74a22dc21ee190a0e321a2f30b9bb2da97042852ea8ddb4c8eb2ab3566ce" => :sierra
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
