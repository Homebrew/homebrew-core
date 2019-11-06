class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191023140354.tar.gz"
  sha256 "1709f2cd2131e4a42cb43b2f696b34eb130d94aa25bc645a4640bf88a0bfff51"

  bottle do
    cellar :any_skip_relocation
    sha256 "b55525ff052a0585474ca56e10d02a24137b54014d0309593c02700e3a1710fe" => :catalina
    sha256 "a2031b8e63d8cd56a53c8f8f7da0345d1c35c6a075403e23214ef4d93352e90d" => :mojave
    sha256 "ea48b58712e0c930b976799f226c1699d92093f149db131a4be03f35256a4020" => :high_sierra
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
