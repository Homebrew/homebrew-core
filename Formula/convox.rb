class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180618130923.tar.gz"
  sha256 "1c22ee967754ff182a34dd06341dafe7b8865e6fe163cd1590af167cb7019362"

  bottle do
    cellar :any_skip_relocation
    sha256 "93b1540983cefff7c44dc0a8e129d25da5e0adee4d1a546ada62d444894dcdd8" => :high_sierra
    sha256 "871032db2ef2068526b3a0b1946a00cd6a40fe174fa160c8c3cab0f805ed0d17" => :sierra
    sha256 "304ac439c0fa58c1dd6d73398a175f326c090e07a14a085059b0c5cf29df205b" => :el_capitan
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
