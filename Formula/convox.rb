class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190701134654.tar.gz"
  sha256 "af706b891b7b50430f721207aa64b79ed04bf77c8e751d9cf1b549c7b48352e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4fb6ea8a8e22de7a4ad6f3074ed068498568776f2d93d2bf481e9509f470b3a" => :mojave
    sha256 "db0d5f1816760f28440cc47b8b57b064471e4cdec4e9abe521257a6210aa0063" => :high_sierra
    sha256 "e6db1b6c63212ff368cd962a9c092e291f9d4f2852624d8d64c8004048d85b30" => :sierra
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
