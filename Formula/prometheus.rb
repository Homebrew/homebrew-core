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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83d3440acdf1cf5350069685e70b57d61f03534bb10f1fb4e217824ad7bac571"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "964553064fc2d2f6c425b6b8ef214ebc37299768ffa366c9df31de1571210704"
    sha256 cellar: :any_skip_relocation, monterey:       "b9ee25df470a3c6b45b8ac738965b8669813ff14ce34d9af04f7f5aa68145545"
    sha256 cellar: :any_skip_relocation, big_sur:        "02df6d1dfb67ff5ecfd7236c6469accde1af8f3fa95ea4e4804efb20911c766b"
    sha256 cellar: :any_skip_relocation, catalina:       "6ab98b73a1ffc682fd0eb639aa78f1462f43c9aa6780065a4f0150f38da6c17e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b0183699d4008192d34906749eccc2d82f4857eb5d5351beb694dfdccada7be"
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
