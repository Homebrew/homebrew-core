class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.1.tar.gz"
  sha256 "8b75f877445d60c86472eac77d122e0cf1f85d5f771d2a2a1a39241e6f6c5d5f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "305993626c716f37e18c41c132f1a2f4c18183381aeaaf45184df541f310fd8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "305993626c716f37e18c41c132f1a2f4c18183381aeaaf45184df541f310fd8f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "305993626c716f37e18c41c132f1a2f4c18183381aeaaf45184df541f310fd8f"
    sha256 cellar: :any_skip_relocation, ventura:        "3fe7b724131a70df4750a054b0196d243b411c1f30b1a5d0088e53eb70618f68"
    sha256 cellar: :any_skip_relocation, monterey:       "3fe7b724131a70df4750a054b0196d243b411c1f30b1a5d0088e53eb70618f68"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fe7b724131a70df4750a054b0196d243b411c1f30b1a5d0088e53eb70618f68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fcdff93cb7f578d82fa1f5145d4551d89e55cc9dd682c5edf9530eb167a6ce2"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
