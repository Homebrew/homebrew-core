class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170721142900.tar.gz"
  sha256 "a492f62d8d1cb05c1a1186cca2ff75dde3411545649d10efb7c8a8b3a8c85805"

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
