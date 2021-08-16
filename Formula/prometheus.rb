class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.29.1.tar.gz"
  sha256 "727c088dd7275c769403d5c284cd2152dbc98d0e4ebfd55596f5f8e58c76473a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "50ff97cc416ee0309dd9668bb25525f2a89c7beac661deaa0a7583f33c780623"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1423d4804ba416ccd034630205181fb882ec7fbf9818eb0ec5ebff3ab5d682b"
    sha256 cellar: :any_skip_relocation, catalina:      "0bde01c5b76be229c324b920bc4553bd24c81ae43d124144be4eccc55874bf55"
    sha256 cellar: :any_skip_relocation, mojave:        "7e34008c2372c3c754d6c51e7550d254c755722839d19f2b998c863c6666e7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b280a87f8926cf91e4e74c6f66216b3c9209ea491bebf2451c3cd3ad07f28a7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~EOS
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    EOS
    etc.install "prometheus.args", "prometheus.yml"
  end

  def caveats
    <<~EOS
      When run from `brew services`, `prometheus` is run from
      `prometheus_brew_services` and uses the flags in:
         #{etc}/prometheus.args
    EOS
  end

  service do
    run [opt_bin/"prometheus_brew_services"]
    keep_alive false
    log_path var/"log/prometheus.log"
    error_log_path var/"log/prometheus.err.log"
  end

  test do
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
