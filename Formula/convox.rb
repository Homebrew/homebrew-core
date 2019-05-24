class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190522175056.tar.gz"
  sha256 "4c35938392637be69e97dd98407cde7fc11719cb9a8c2bd0812880b89b5b4000"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a6d0882d5a61b57a51efe756471417459a4a22c2acbc977ce85af35debc4a3b" => :mojave
    sha256 "283ee7b3f44d37287c064ec0298e1b40ad8b53057f74608c2d51755f8d7c629c" => :high_sierra
    sha256 "0a80885e8c045efe1b9db051a35454d0a8edd0da7443395786b6d48fe38ca34a" => :sierra
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
