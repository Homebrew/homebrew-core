class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180420210156.tar.gz"
  sha256 "ecfa5821188001f0749aa98bb73f0c91b3abd3fcc820ba901c395ca678dbae8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb2b6815b79807d9d027521ea781bd24d7b70b33ffec2ff9bedf9de1f0400f9d" => :high_sierra
    sha256 "85d9f77afcd6c43dcd8f3137b82f50108835ff72419b537bbe55c386886d7687" => :sierra
    sha256 "c240f72618aba458c55440c0cd185bc7ca33a421fcf8913c0a58f2fefa347c3d" => :el_capitan
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
