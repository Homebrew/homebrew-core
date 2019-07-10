class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190708213559.tar.gz"
  sha256 "9381882e4fc00c7053249d488be1f6ae254001c4d74622ea0779ee16fe72c9ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f73516cb3d41cd32dcdfdb6ffac6209a64744f6bb046eef6c4cd58fe49368ed" => :mojave
    sha256 "3a63c32aa98b90a288b66f57ee9a5ad4720b32d9f111147c4d2855b84bef73e0" => :high_sierra
    sha256 "d59157cd6ca04ecc83795cc2d05f4786fc97e90a0081c899eb006c8f106f0a09" => :sierra
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
