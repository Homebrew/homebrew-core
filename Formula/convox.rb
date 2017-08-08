class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170807174226.tar.gz"
  sha256 "bcd2996562a88cebff04f7c0272a8953ba46d2b142304a3a7da91e9de9c6ae8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "12778b2e660b16e20cb8291e10d5be9e7f70ee6c68ff98866b4a7f94e1c521cf" => :sierra
    sha256 "9aef16522ff44f7f69213ad272f8bfab319b520a798b16c97279fc4ce1987ab7" => :el_capitan
    sha256 "859e7449dfa0ec0b040fc7350e4d12703e6116e2ead5b7f212e298d31361c39e" => :yosemite
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
