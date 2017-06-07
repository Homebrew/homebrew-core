class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170606013346.tar.gz"
  sha256 "8556661668f961b48925dce6467ac30b68e892ec4521d0ffa618f865bdb7b5a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5d4aaed7bc40562a481e771d9193b15fcce162477a674570629f34857b1d4ca" => :sierra
    sha256 "a9f9856d68b32e04921dedd865b449e3e6f2c4ecaa5cb6041cbed89069ec9d96" => :el_capitan
    sha256 "62bdfdf18553027ecb5d27db3e30b150173a125e89600a9e0bb2883409b7ab69" => :yosemite
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
