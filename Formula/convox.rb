class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170427232658.tar.gz"
  sha256 "e852589983cfcdbcbbbbd58b55690f587ce9d8e98ad94e3c1212d5befaac5ada"

  bottle do
    cellar :any_skip_relocation
    sha256 "6416d93f870025d5649f10603fbc706bd097287f22fa13f5426df3e851f6921e" => :sierra
    sha256 "ebf0297d367543c4dc359e0b1c447d9029bc7c519592dda41b423411a6e2d2a2" => :el_capitan
    sha256 "e9a8cb7afe8f1d0f41199aeac3644b374a893434ba2305b54ba624dc6e3236ba" => :yosemite
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
