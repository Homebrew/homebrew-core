class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170427232658.tar.gz"
  sha256 "e852589983cfcdbcbbbbd58b55690f587ce9d8e98ad94e3c1212d5befaac5ada"

  bottle do
    cellar :any_skip_relocation
    sha256 "c07be92052b97387d330c03c323c8eaa9f1d0f9473d7ac4d8559aeacaab18bae" => :sierra
    sha256 "8fcce08b730bb560a5e7a0cac179b86d51388ff2b82a342f6c61d4285d2649d1" => :el_capitan
    sha256 "469dd29ddf3467ec731b84dc78cf4b6f3db4f7d51bcee475dd1940e7a5651844" => :yosemite
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
