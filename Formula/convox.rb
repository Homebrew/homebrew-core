class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170421193816.tar.gz"
  sha256 "53ff0673454ee9f30728d0ed569d5eea8bcd0129c346f70bc25ba1a6d98f78a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d6bd255263fab3afcb7d119bf324d91c379cdc00a9e601c18e431a58151cf0" => :sierra
    sha256 "868dcea23892d876175c0f8accb67381fbed46a6d3dca0588bdab75a5b2f0897" => :el_capitan
    sha256 "0eb772c541fefc8ef6e402ca7f7728fc90bb88c05bdbd721d34a45ecae6d02d3" => :yosemite
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
