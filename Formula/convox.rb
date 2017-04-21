class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170420220644.tar.gz"
  sha256 "e38c814820556565292d9c45f4e14d5eaa7df46bc9934eaa1f526c0399d9e5e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "805c5da79bddbe710e4a75d3dfd66c54795cdf0cfdd1736738756d0c614e17d0" => :sierra
    sha256 "226aa2c1031ef0486cdc7410a95e3522b3bb50753b95ff70826856c6a8b3cceb" => :el_capitan
    sha256 "4ff57babced6cde27c1d571d697183f2c874fbc6495f5195970fb9c429e42348" => :yosemite
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
