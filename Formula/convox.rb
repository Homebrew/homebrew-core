class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180708231844.tar.gz"
  sha256 "b39c43567ffb8d13ec272dd2ac6dc88b14405e3a01760efe382c06cec9f4f0f2"

  bottle do
    cellar :any_skip_relocation
    sha256 "1edb3f2b359f575769e1eb16156f3a5ff5db8e04e49f6983351c8e89debe9900" => :high_sierra
    sha256 "9344af0abecee2a2c0368efbe1d8863e8fdfaa05b1f235e1561be3c5edba4e98" => :sierra
    sha256 "2cec5062892f9448fbd834ef93f8c3c371404cfce8aeff5ab4a7a5c3604a6656" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
