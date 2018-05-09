class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180508174756.tar.gz"
  sha256 "9e6ead43bd341758c1ea9b66409964b864a364a04259aa303d8d4bb81c895703"

  bottle do
    cellar :any_skip_relocation
    sha256 "49d2b29193ab45303a5217d5decd06b1cec6517970df413619a7eb4b3895fe31" => :high_sierra
    sha256 "c99c02f757eed4bc7cdb1826cc4dece242e33344541fa13b04222fdd942ac69c" => :sierra
    sha256 "15bea3c86ffa077cf8c0ec7fd8bba6df0148336d6be7971b5516e5d1c3f068a6" => :el_capitan
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
