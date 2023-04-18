class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.0.tar.gz"
  sha256 "b54c4b11c935f267a80693a97a6037ae7fb5cd2a25f30fed17d994d134a1ea3b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17e1878dcbcc66fa8953a009295e271cd12e99b2437654ec540cc2c8491fe59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d17e1878dcbcc66fa8953a009295e271cd12e99b2437654ec540cc2c8491fe59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d17e1878dcbcc66fa8953a009295e271cd12e99b2437654ec540cc2c8491fe59"
    sha256 cellar: :any_skip_relocation, ventura:        "9120fa9d254a0b42dfa332fa83c54f1b03c4d25748426803ee3da8f2fc20def3"
    sha256 cellar: :any_skip_relocation, monterey:       "9120fa9d254a0b42dfa332fa83c54f1b03c4d25748426803ee3da8f2fc20def3"
    sha256 cellar: :any_skip_relocation, big_sur:        "9120fa9d254a0b42dfa332fa83c54f1b03c4d25748426803ee3da8f2fc20def3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "482faabccc857a27f5da56e4ab69f4f9245cea1bf2091e85b8112deae9804743"
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
