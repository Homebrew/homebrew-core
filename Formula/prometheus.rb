class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.38.0.tar.gz"
  sha256 "311f9f2f867ee0f2bef5c8227bbf672edf4037b6fd5e036c45ed7e947d61c375"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207c21888dceb65a47e344c84a57866d8bfcf41a7b9670bd21747b21795d2c22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cd7432d1224270a68c57bb3457c69cd7d30ddd7a39e2ef2d295176990ab4cf8"
    sha256 cellar: :any_skip_relocation, monterey:       "2cfcd9bd46d640bbba31f9e39d3c619b0f7f5e56a493c8f9036736e4cc45c1f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "483e722a2159c2f0b181965d8af621c04e46820e3a798928bb7513ae9b5b756a"
    sha256 cellar: :any_skip_relocation, catalina:       "1800cc6677dbd70eca8f01641998b9faa5d3925b11a14e67d5a0295b3ca4512d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b4cf6aeabc73c45290bd4e9fb9cbf0b3c27967811bcfb8f8a047e5feff0eeb"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", Formula["gnu-tar"].opt_libexec/"gnubin"
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
