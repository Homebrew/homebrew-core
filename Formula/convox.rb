class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180809150504.tar.gz"
  sha256 "429636ce0320fcb19ea23f4cd3f8688c9533d5251ba053e06dacd7bbec427f6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "30adc04e0bcc5dd12127803b8e7d2e867faf4a62124bd078e9d992e1bc9d1b41" => :high_sierra
    sha256 "d42f8111284a2a57e278f6468dd44d09d733d37c9603bf80b121c94410b590c5" => :sierra
    sha256 "ac06f54709989ca5ba2b31579e72a36dd6f5a6483574a8984d12e76d10e62d6a" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
