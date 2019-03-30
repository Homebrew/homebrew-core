class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190329133039.tar.gz"
  sha256 "9a5c2d9cd08d814bfe1acc919477ec7ebb3e8e7fd3acf26abfd7d8e5d3427f60"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d859bdce77b34b21676d5825092fe566c349032d86ec0a31ad741a734599420" => :mojave
    sha256 "4fa8f7bf0e82f0e67c00e68150dc67242794b2ee4706e8aaf6c914a3f1f03558" => :high_sierra
    sha256 "ade7bbb5ec769fa40d8b674d66a82d6252e5e9cc020d3f9b6b00dceb913cf510" => :sierra
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
