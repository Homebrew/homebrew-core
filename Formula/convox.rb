class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190219181019.tar.gz"
  sha256 "55a96bc9a0c3fa07e717b33b32b8c3bc1eb61bfa31fb656d0763932ec9225fed"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca403924e1982359c928c7d1978a2d753724921eb5c038c59cbb9c268f4894f4" => :mojave
    sha256 "ed9d644bff3c8f73296a550a6de67a6fb41b91148435e67759886b7cd9661c71" => :high_sierra
    sha256 "53a740fca891784123a80c440cc5b166a48943c5f9932bb519fd17a5cfa2fd29" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
