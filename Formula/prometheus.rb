class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.31.1.tar.gz"
  sha256 "869a8be315721115be628f766ec3ff71aa50f1a027cee776ea54d7ba070a5026"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a7bc3dff7ff880ad890b584679dfc703a91ac37ba18fa96dc01aa942913f89e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc38f1b1c48753e2dd9971381ef28eb7a81a69b96cd4773d6f97852f3fd4ced8"
    sha256 cellar: :any_skip_relocation, monterey:       "b13736fc0c784a2cf44a8a4a71aa3a516d2736110b8294240f2152cb43694bfc"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a2dd58cdf2285ba7579c24a6fe736c10f5d43bfe2199d7e9f8a691c08e4343c"
    sha256 cellar: :any_skip_relocation, catalina:       "6f71dff1ff688a6fb681e64bcac81191d49765f78ea0fe8ea4789c81741f947e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c458cd10b005881f3996e9ef823528d5750b01bc0c70910cc6d04880c9a0edaa"
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
