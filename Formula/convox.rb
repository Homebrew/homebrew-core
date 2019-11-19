class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191119180459.tar.gz"
  sha256 "8025fa5367eda9bdb188ba1f9fd74873bfc6529620fd529cdd77c4dfcda64107"

  bottle do
    cellar :any_skip_relocation
    sha256 "1024d8e500990a70f01a9aa1161010aff90bef2d60b7c7ce39ea8b0f2416873d" => :catalina
    sha256 "171ada99ad45b701931263c31099e1c8f85ff0c57a8c3e16a24b9168dda6a3c7" => :mojave
    sha256 "0988f91aaf5391c62c4eb239cb6ee1f477e59865855bf1166afb0f42a9a78cb9" => :high_sierra
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
