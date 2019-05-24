class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190522175056.tar.gz"
  sha256 "4c35938392637be69e97dd98407cde7fc11719cb9a8c2bd0812880b89b5b4000"

  bottle do
    cellar :any_skip_relocation
    sha256 "68a772f481ecdf291c1e3d168fa0cd865836692a9691e6bc9416793fd98b879e" => :mojave
    sha256 "cde7a7d741d4b3dff4a110478031abf22d0da12ed9bfc3aefe5bac7ae9cc9555" => :high_sierra
    sha256 "acc33cca106024a6398047e274cd4983dc30ca1cbc1ee4178ecccf644eaab590" => :sierra
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
