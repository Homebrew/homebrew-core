class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180625222015.tar.gz"
  sha256 "22e8bdf2a04ab4222a3572640cd0cbd6865cc49b4dc8003f9930cb6ac9c7b07f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a36626de53d0aa1ab2a662b46e8f0fcd3003b0f90f273f971457334eb2d0669e" => :high_sierra
    sha256 "da2e9124189b561b3b9d0ae28e19684c88c283f21677b3b0ce941121823aa10b" => :sierra
    sha256 "5afb9c386d41957056cc77ab52d6ccecc34fef7cdb10c180b417a9a918ff781a" => :el_capitan
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
