class Convox < Formula
  desc "The convox AWS PaaS CLI tool"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20160818150650.tar.gz"
  sha256 "da665756fcb63afe1f8c73c3bebd626be82b1d7d71e40683fd91d0af72c2c00b"

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
