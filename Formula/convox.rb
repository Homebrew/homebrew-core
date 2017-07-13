class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170712160322.tar.gz"
  sha256 "476d28bb1cc459ebed45895f6368cd177e8f989385961db5b13518ea8e0c1be3"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7b7137069ff795ae461859b92e162ca69b6d4fd46b234fdd38e5da13fef6526" => :sierra
    sha256 "7abca69ca55c6f995b09a4a33c6242f736b86d30589fade6a9859a8875f19c5f" => :el_capitan
    sha256 "5fa22fe7984ec11b68a97bc1a26238450a55e4ada38395082a0e4632043447c5" => :yosemite
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
