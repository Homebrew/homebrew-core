class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "05c5d23eff751b9c4f4e49918359e35b7ba840a5b504e3eac0befe4ad94ad464"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  # Promtail is deprecated/eol and upstream removed code: https://github.com/grafana/loki/pull/21245
  deprecate! date: "2026-03-02", because: :repo_removed
  disable! date: "2026-03-02", because: :repo_removed

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
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

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
