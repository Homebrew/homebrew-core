class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171214220445.tar.gz"
  sha256 "c0391c86e19feabed9da436e2ba28bd5f1bc4874f1e46e7becdffe45aa659bfa"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c5e1485196c1713d8839d5f111026279ec5d420e0ad90dc049551e4f5d6a39d" => :high_sierra
    sha256 "f6a7d8c5761dbf70b3a0b067f842102b207cb242ff5c21fcf13b05c2c757f787" => :sierra
    sha256 "e67b00c6812c9ad4a8cf98e07f3004e859efd0d042c13e8f8554974f4e90edbf" => :el_capitan
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
