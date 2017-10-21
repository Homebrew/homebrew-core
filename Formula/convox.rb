class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20171017130927.tar.gz"
  sha256 "e3b6f2d3242777a28999a4b21b0e32b821f8d683a9d52297bee940bddaed5bb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba5e6a84bfdfe3fceac040b14c8e61a8ceb3f0c25f3f7ee73e64bf9e09b66c46" => :high_sierra
    sha256 "683740d22a4c6da0a2d4e48e8ec33233fe76315bc911ad21608f61286510f294" => :sierra
    sha256 "0f64b39e713602bff3dfd7f26df8dda85fb529b6ef7794bbed1d95f0a1f58277" => :el_capitan
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
