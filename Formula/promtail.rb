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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c9f483122df447662d1c14c2b24f0bd4a1c5f50b72f993adc9944011b85664"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08093f5b8441cccc813d85d2c9d9103275cda01d37f3e5427f431ddfd32dba1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7325a77661d080ceb49b8a78bbc75d01d01dc616aa6624b44f5eaa620bb2d51d"
    sha256 cellar: :any_skip_relocation, ventura:        "ce0effa9e159583ae60f47c89391cd24460da8113aaf8161f240943603bae3c7"
    sha256 cellar: :any_skip_relocation, monterey:       "31e039aa3c0f13bb75c57bd1b2733cd225256dba73825ab54e82a46f8db1efd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "454aca2431d3185e1179630b7b71700c22cfd4dfb838cf1b029ddcf3bed90838"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c874f61a5c459aeeb973459ebd3551cb5092b105e54d8050118a1869d98b0f3"
  end

  # https://github.com/grafana/loki/issues/8399
  depends_on "go@1.19" => :build

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
