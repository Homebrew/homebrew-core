class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191216210003.tar.gz"
  sha256 "35955a9d79fcc7738442b295cc3df1e3859f80e1f0a6885ef666d8ba3adf0502"

  bottle do
    cellar :any_skip_relocation
    sha256 "2254c33e4edf03ba11df61b2e3a26b08dccec39aa3570bd3274dfac33e0c6025" => :catalina
    sha256 "a1eefdcd2606c56551f035c5da86d1a857d2c5ab5d1a71d7a783ced8e8c1dc62" => :mojave
    sha256 "286490a117e211cf2ad3b5385ca352d30e1331c067d6279d9509a7b4280606ae" => :high_sierra
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
