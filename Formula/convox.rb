class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190701134654.tar.gz"
  sha256 "af706b891b7b50430f721207aa64b79ed04bf77c8e751d9cf1b549c7b48352e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d249d8409b6f810a26f2bae38a9538caabc960e4bb12c0a39503f768c789700" => :mojave
    sha256 "7c20596a12edc27af113b048525f08cd9994d1b3adaf5812e43fb7f047165a4b" => :high_sierra
    sha256 "8efff1d3a7a060571c1d7d6ae03726d9263b9d6d76a1e2ee5751d0bd15f88c4d" => :sierra
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
