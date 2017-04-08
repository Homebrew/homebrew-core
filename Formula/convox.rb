class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170405220740.tar.gz"
  sha256 "5eb2995cd29650fd14bc815492242730b14cecc98c4695a43f10f909ce95aa9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "022bc6a576896191b5ceb4b86600157a21e979312b82ada207a3a006ee6e7581" => :sierra
    sha256 "b1bb469115ed318329fcf027ded6427411897dcf9d474ff53d4b6cf358c789ce" => :el_capitan
    sha256 "d31f3002eaf3336bdbee2260b7fa20fe9daafbe1de472495e7bf180b5c7ae1dc" => :yosemite
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
