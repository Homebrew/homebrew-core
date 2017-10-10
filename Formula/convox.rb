class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171007002353.tar.gz"
  sha256 "ad9212d7f08edf890433b0c6c4a5359ddb05c7527fd1d2b1d5d9b54f54ecf396"

  bottle do
    cellar :any_skip_relocation
    sha256 "696bfb6fdede47eb8fc60faf6e23d2d9076ba557f630f79c4a5eddc1c1799ce4" => :high_sierra
    sha256 "3e3e48d8f865bc806dfef4c09a23454ad755c1ac4df37fbc16fdc1a39ffa6e34" => :sierra
    sha256 "92148cc30afdbb275a3d8b45309addd7e482a97796e86b4c333bef4e0cc33b04" => :el_capitan
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
