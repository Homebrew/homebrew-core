class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190329133039.tar.gz"
  sha256 "9a5c2d9cd08d814bfe1acc919477ec7ebb3e8e7fd3acf26abfd7d8e5d3427f60"

  bottle do
    cellar :any_skip_relocation
    sha256 "521640177b0c62f8b88618bdcb06e8acb0888331ba3bef67a79ca2249ecd6614" => :mojave
    sha256 "c346848dbaea366de0c7d1bbaa81e85d11febc113bee8c71640a2ff17a60202c" => :high_sierra
    sha256 "6f78b2bf5f731ef41a80609fa759209e7ebda390e2f0624f50fee64e26c2e586" => :sierra
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
