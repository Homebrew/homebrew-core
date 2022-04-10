class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.108.0.tar.gz"
  sha256 "fd3f4f451ead288622ebf122bb52edf18828a34357489edc8446c64b0cc10770"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f847761b9e25debc83137865023b665c5015c3fe3135978f3c9ec2c3d3b885f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80368140208c348323b836bae15b30bdbbf28bda02e5c5392c4c126c321a3ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "560ac224e5ade3eee2a0cc76d24f5ea818f2ff192da51862a7a40cd85b8ad7b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "862f022a313c230a1f79b3c4b8271ad8531b2a576e698749f38eaaf994afe83e"
    sha256 cellar: :any_skip_relocation, catalina:       "6aa0137011713f4d3f05464d73226f681e9045e2e671d1100d987bc2501692df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c549041814afe30f7c0a7e1e5c0f132da481e800ea4870d52f54174e95b04cb1"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match "200 OK", shell_output(cmd)
  end
end
