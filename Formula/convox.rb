class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180809150504.tar.gz"
  sha256 "429636ce0320fcb19ea23f4cd3f8688c9533d5251ba053e06dacd7bbec427f6b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "60e0df11546ac449adf6a5f7c60883e3caf0d2841684b6722f178d38fb2cc6ed" => :high_sierra
    sha256 "b9b98320b1111873703da6d887199d3252daeebc2708ec21937bf4a450d4ac30" => :sierra
    sha256 "db8df5f40aa480bdcc964cbb794988d2a823ddf0073962f3f09353dd954a4814" => :el_capitan
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
