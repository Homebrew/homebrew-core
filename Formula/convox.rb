class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171107141806.tar.gz"
  sha256 "100730be407a36eb7e9cc5a9065b6bde42abdbe5ddb386e913439586542cbfae"

  bottle do
    cellar :any_skip_relocation
    sha256 "9319be52c93147eaa05afd3cf67b19e1bebaba889dad1fc3b9884f3af666ddb4" => :high_sierra
    sha256 "6a6abd96331d5f9d0a5c4917599bef71ff764dc65c81e65d3d5e867f6e5218e1" => :sierra
    sha256 "ab2fd38e2805ce7e6a0232b5d835fcc58dece9923430a2f6d36e30b1ce032d74" => :el_capitan
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
