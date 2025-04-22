class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "00b6b671c1e5fbd52ab1fd014bb8a201d32fe01d9998a28d7dcc933a2c3e5f77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f72fdf9475a2db7fee8f1ad3ccc1927f3b0b5de6dbdd39d084333f8299fb0a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e055020e20add8f4556bfe6074fdb4212acc4fe367a0f8fc69df38ec71ea47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6bf7f286a200ed84663103becae407015835bc9b300d88e884a92546882804c"
    sha256 cellar: :any_skip_relocation, sonoma:        "47202a5452ba969726eb9e2840a952d8ecf5d6160a44119e5297290c973b6cc8"
    sha256 cellar: :any_skip_relocation, ventura:       "36d921fa8bd65d2a1a3f7a86639c1478d0a7295b232ad6c8521a47229dc664d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7545a68d284df765244712162a611dc87936c8f7558c85ed75485ae8cf5674"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
