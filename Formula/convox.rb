class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171023163225.tar.gz"
  sha256 "0a1fb4b4298179ef7400b37d1a5fb875566c514f8e36aa80ff36a065eeb21616"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b8c663f1d145390163c05c42a876323b89e4d696c9dd947d7ec72801a4d523d" => :high_sierra
    sha256 "b99b90038210e8edf1599cae0ae9439686c6030066feb16503616cbd29fbc2f4" => :sierra
    sha256 "f496a2e19d39bdc30440f16b5be26cd85b3487daab6c6caffa7075bedfdd459e" => :el_capitan
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
