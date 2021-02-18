class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.92.0.tar.gz"
  sha256 "c2e835ddc61092602d5032789dcb630a564d0c8f804911cdb8cf95c57587466e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "61b28ebbcff9dbb211adc7333ad2e1e8e5e6dfd58d5253f36fd7b3f01983b411"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8cca90b6aed467cc1918e9cd777a5e52bc40f9784dc42a0f20ada2b24c89aea"
    sha256 cellar: :any_skip_relocation, catalina:      "ab14b37127349b81975a74693253a6e14bc5320d575c69a88b1d82edd1b3b877"
    sha256 cellar: :any_skip_relocation, mojave:        "703b6f6e028d054128620aedaae90275637b5f442746b97f5a2ce52f790f84fe"
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
