class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170814195559.tar.gz"
  sha256 "ab754793e9924ff15dca29e838ded718456fe1520c65b0df27b5cd2de949123d"

  bottle do
    cellar :any_skip_relocation
    sha256 "39d6a9cbdc30bcb44dbfe8bb0e8ca013d2fc43e3ab4a339e2a2df891232bbd5e" => :sierra
    sha256 "6adef69f0544bbd02e1eab6bdff9c54ed4d8a3e87857594e574ed7377e2c7d4b" => :el_capitan
    sha256 "3faafdff26ba80a0eb7b3849450831fc524342196306229b83f0bbe37f41bd42" => :yosemite
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
