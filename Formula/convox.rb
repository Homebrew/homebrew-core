class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20161028232500.tar.gz"
  sha256 "f108764a3a1637f63c2433db507ef0f406525f17bd055d33ea9d1fcf22fe8d5b"

  bottle do
    cellar :any_skip_relocation
    sha256 "8890b9e8b8c25619fd5c1f2ec04a8cf109396ba05dcc110f2839b00a7905b5cd" => :sierra
    sha256 "8978c0ad3e1e47a1bf36c1e6d890065ea0343d5db8b1bc36fd1db59ddd16c04d" => :el_capitan
    sha256 "41c67e100268d95315bf23dcaf9016c465d0709e8c78df4dfd6afb77857c71f6" => :yosemite
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
