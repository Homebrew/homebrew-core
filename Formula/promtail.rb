class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.3.tar.gz"
  sha256 "07b7030576abf4ef63febf4dcddf95ff935aab6d9ab4fc0404322794d94bf3ee"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24f7b883362d05acd1c186866d57f4a1bde0fa6a21658755939a2d114cc831f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b94fefc5a146defd4593395dfc001ac4d7e9a18397bd8674f51d17d701de143"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "738827d1fcc39c5f09bb65aeb5ecf22abdeef2096aac36fcea5f8e0b957ba3bf"
    sha256 cellar: :any_skip_relocation, ventura:        "35f465081e0d48af1f81cb3a2b9f6bf0a642c5537d243b40e646f4fb0d68d32e"
    sha256 cellar: :any_skip_relocation, monterey:       "175e0d3768d892cfc3c5d0c0392a857effa5154013d8f51b68169891a166af14"
    sha256 cellar: :any_skip_relocation, big_sur:        "4999ce6dba0515957e0f404fcbb81e79c022cfe0b5dd8c8b277bf2a49b41f4a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ecb476db14e6adc28747cd30f969153ca9940914c8b5774f7ea8135c8d7137"
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
