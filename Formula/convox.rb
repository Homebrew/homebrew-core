class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170629200707.tar.gz"
  sha256 "b3c2dfdc10f29c3a7fa6ccb1e1301aa580a205871022928ced71701f45a0b582"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf69402f6710178033ef2f78bd44b389554d6fec2c33664ffea155c9e152f816" => :sierra
    sha256 "2ceb10bba0f2c85ddbe78e05c56c8fcaebb696492f559a719f695e5778b37500" => :el_capitan
    sha256 "0756a3da7d7bf3af24a7cd992cc30ca19fb336ebb45338186be4d738044f3cc9" => :yosemite
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
