class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171021214545.tar.gz"
  sha256 "a5634ace9baf1bf1d078cba02165b4a23bdcc509fa17405d8f84a3df2838eb98"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b578561e0397809e2ab5d030933f26f5a626d8d43443e66e940b0b245e912e4" => :high_sierra
    sha256 "62d015b3f95e4383714e07a2592febd43e5774500f960bf65773217d64861856" => :sierra
    sha256 "a4f972ebce4c31b330994ca7b2e649be131bd166e0d7d00040d55af76c3e27c3" => :el_capitan
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
