class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170925221816.tar.gz"
  sha256 "557d700c34dce238eb263fe0ea1970cc9a639d0146a092a4dfa2bcf2f8b56304"

  bottle do
    cellar :any
    sha256 "b8fbedac564c4468a3bcc7099b72032250470f900e09cc17eea4b109482b2c3b" => :high_sierra
    sha256 "f7ac6969159e84cffdcfce7a5ca149161560b149b5eb5f00aae5c9e1c04bad35" => :sierra
    sha256 "ce2348474088561fccba5d5f79216d208b4aca578b92d732b123cf4940e3cfa2" => :el_capitan
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
