class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180625222015.tar.gz"
  sha256 "22e8bdf2a04ab4222a3572640cd0cbd6865cc49b4dc8003f9930cb6ac9c7b07f"

  bottle do
    cellar :any_skip_relocation
    sha256 "c11311a9575f9450456e5d0156baaa7cb252267d2d5da249b77509897d937c8c" => :high_sierra
    sha256 "a54c709496e90b67c8783197a07c1fab8dcf93d66fc790578a58f4be19645a10" => :sierra
    sha256 "2baacac855e5dcf4e1255017ee226c9c33760dec75749d726c6ac2df9758a68c" => :el_capitan
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
