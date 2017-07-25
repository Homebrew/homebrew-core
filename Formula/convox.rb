class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170724235705.tar.gz"
  sha256 "bf3cd3283429051cdb51c3215533920ca172109b06b4e5e51d1f77a66c5e5464"

  bottle do
    cellar :any_skip_relocation
    sha256 "265c109f77007d5d1126c3480cb0fe60f2114abc7429316d5f4acf8a4fc567e5" => :sierra
    sha256 "7cda5bdbbd9113d6bb70f68eddeda7da2735bf08c43c8c7ee9a611b1d6c11170" => :el_capitan
    sha256 "f4aa4f69e9ac69757caef5cb55598d48ee6102669c72e64e198256b004faf254" => :yosemite
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
