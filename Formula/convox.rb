class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171017130927.tar.gz"
  sha256 "e3b6f2d3242777a28999a4b21b0e32b821f8d683a9d52297bee940bddaed5bb0"

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
