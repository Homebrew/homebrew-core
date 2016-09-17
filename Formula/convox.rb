class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160916121812.tar.gz"
  sha256 "274cacd4f232d751e5908dc9f6af54f3a41f9a2d8b2e78ba814e9b23d414ffc2"

  bottle do
    cellar :any_skip_relocation
    sha256 "66d6b02d5e0fdf205e32c0dcfb1c9d2466cb0627a7a730d0b99719b42532c645" => :el_capitan
    sha256 "421a4701b0e2c06aeff7cd4b75829f793117bd4f4bff168e94c5faba5895c0f9" => :yosemite
    sha256 "f14467a7fa6133f7f3df83e60cd1ba94f7aa76d3276b9d9b8c2dcbebae8367cf" => :mavericks
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
