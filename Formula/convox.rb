class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190529174125.tar.gz"
  sha256 "6d94a3a789109d3130d07b99a4837b0eaeb52d0124ad3d6e523cc085efb714b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ebeabd99d27d7972bfeafebf666e49a974fc702a69a09b06ae6d00a01f7951f" => :mojave
    sha256 "09fb685baab43004a92a150ed5cb98b357493d207bdd93535065eb6628ec5948" => :high_sierra
    sha256 "32b29aa38e49dcdc836623dae1a161e8e48b4150f94e108c7bf73cd9aab432ef" => :sierra
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
