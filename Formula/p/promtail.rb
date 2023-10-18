class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.2.tar.gz"
  sha256 "9c1a153ab4d57d5c109dbf55d4ea5aeab2159ccf51d3b8cc8fea19970f0a88d8"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c30dbc9dced92a8b5c15de1dcf04be786f3694df43384a1d15e09e8fdfe03ec"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "346c43afe5f97f8bc7856fb721387587782ead8cfb3346ebe95c1e1a42ac95dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "056d2ecd0faafca8aeeb45fb565950408dd02178254bb1d8677d6a11c8f3acc8"
    sha256 cellar: :any_skip_relocation, sonoma:         "f732e32c4eebfacbf9b68599865b23983e8973b5e15aff78341d7f19fbfbcb6b"
    sha256 cellar: :any_skip_relocation, ventura:        "5fbb8f8c5670a617e587250f00ccba0144cf696013297d16319e7bf6a2d96437"
    sha256 cellar: :any_skip_relocation, monterey:       "c0b1aff7720b51b23c1419f6cc9761b251cebbacbb09c3d431ebc1b168017406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f5c256b14a39e722a54181d0a32ed225fac40f258014888aae84dbc80725ec"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
