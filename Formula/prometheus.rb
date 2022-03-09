class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.33.5.tar.gz"
  sha256 "a385dab190fd4bf973a9950d6c53fa9d2b92c55ea2225a53305fe546749ddc0d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d03d3f5d9190f9c0b036d1598a7beba4d8ed9c6c9f26646ce7b38a5a34d04c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a27a1aa17c1c52a53370b1b0c713a5119276a4f5c4c03718a4b61a1f80d2211"
    sha256 cellar: :any_skip_relocation, monterey:       "602a2e74afa18b03c2767ec5ba3bb6b7dababc122bb6cbc0aa9882452f1b9cd8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ecaf44522841ac105a6a2e0f1f59679d9e4972d1a4e85b36a2456985319104d"
    sha256 cellar: :any_skip_relocation, catalina:       "0cd6db0cb4c8349f3872a09eab23590f4cdc22f37e7c0fcf891194193c477dfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b68b6ef85f684ad15b5a9f5b2c5d32ca75a6b665e1fddc78fc50e9e2db138f79"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["node"].opt_libexec/"bin"
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
