class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20181110123948.tar.gz"
  sha256 "aaff22d2c8b1e7db4520d5ec7d30fbf90b7b7910f4511a2f7697b6e5400e0560"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4687367158639fbe3022ba1cfc26846c3b67ef56caf9002b5b6960a9f36de36" => :mojave
    sha256 "1e6200a2c94fd20cc6f03cea315ff786d255926bc72a754dbf7f0742f2b9520c" => :high_sierra
    sha256 "d6c68cdbef59d073831065a377a1073aa54c2ce12947a3a019a3c25b33ea7355" => :sierra
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
