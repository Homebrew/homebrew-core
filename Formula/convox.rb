class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191120232059.tar.gz"
  sha256 "78102c37dadb29f700cb1c6a637b72f271d3279aa8c34f162bd3af4ecd0da652"

  bottle do
    cellar :any_skip_relocation
    sha256 "237a97986dbe03141fa86f824f793d3b7a5f81788e76caa57934c2cb1ca80beb" => :catalina
    sha256 "5c44c353fabd9c9c427b48a1a37de9b64e77a6214b70c3dec16d2927a64025e4" => :mojave
    sha256 "7c5ec1cb9da6c8cb4315bf96edc54f6bbe0aa386808210c600867e1b0793b35f" => :high_sierra
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
