class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160916121812.tar.gz"
  sha256 "274cacd4f232d751e5908dc9f6af54f3a41f9a2d8b2e78ba814e9b23d414ffc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "000a2912accc0eac8450f2bdcf88898e6edb28b65895b6f9ba756754adf2ebc7" => :sierra
    sha256 "266540667bf9d3fa038f81cdc75266de1729f9700f9e7421bc5c97a7eff3ebaf" => :el_capitan
    sha256 "715dcd910d2359fa980025131d567c6da126fd2aeb52e2c364c242bf91190f74" => :yosemite
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
