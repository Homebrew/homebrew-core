class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180815173013.tar.gz"
  sha256 "4ff5d487e964f94895a238b33c040605327b7887269b7eaf59ebdbecb4b32e7b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b88842d39f15077debfbad25af2bc8dfe265ee0af308f56d33f68b0ffdf2be2" => :high_sierra
    sha256 "387ba32a7a03842f90d6569d772358ad956137242318195dd3fcd60ca580f9a2" => :sierra
    sha256 "26638eaf61040da3066ad620b7d2df6a48a83cf156139cf26ad258307d98f5b6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
