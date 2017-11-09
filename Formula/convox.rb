class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171108174212.tar.gz"
  sha256 "193c7bf423662935144cdd41bdef4fc94cf5be3b619c21e9267c72ac84d464c8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f17990ba15c9087d374345ec603bd01d885efd00c65a8b978cac516a0b2db49" => :high_sierra
    sha256 "c204bcf240a9528232de05c58663ae952f2ae36dab37f571d1b9867ec6a26d2f" => :sierra
    sha256 "4764cf9d00a686b2f4e981e87f361acb64d8c480a218fe0c8f4ac95937c90478" => :el_capitan
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
