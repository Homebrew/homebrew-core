class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.99.0.tar.gz"
  sha256 "474c84f9d8cf7da5db177f12b0f0f242b500ff42363323bed39f73b4a318bcc3"
  license "Apache-2.0"

  livecheck do
    formula "ghz"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65b251c68ed2e2b623139665ff9ff927943d775f0711edea521c8afc5d3a3478"
    sha256 cellar: :any_skip_relocation, big_sur:       "49430e8edeb2e79fb259a57375a6d281654d59a7285f8b3f1058836bfb0e2cea"
    sha256 cellar: :any_skip_relocation, catalina:      "403f019ffd0bdb4a6fa51bacbc0c68614bde02ed64bcfe898215a73b89450d23"
    sha256 cellar: :any_skip_relocation, mojave:        "575666e2e170252b28bb342736462e6489f855ee6f9432ed2080c3d78d3fe722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9371b033eb686c3d7bf2647c1af88f203fa6cd70cb60adcc303fe925c47eb4fa"
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
