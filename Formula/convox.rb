class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180420210156.tar.gz"
  sha256 "ecfa5821188001f0749aa98bb73f0c91b3abd3fcc820ba901c395ca678dbae8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "aab2f7a666112b8af75cd4a3f8c03a1f63b503511c42b41629beb590e1ea5748" => :high_sierra
    sha256 "5acbaa3ac798d53458881bf588210c4934aa86bf897c78cab2b0ee692140a5d1" => :sierra
    sha256 "4755830f7850834931f627bf9acf985adcd669bbc9f8604e091b6c9eab28020e" => :el_capitan
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
