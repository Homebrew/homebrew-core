class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.32.0.tar.gz"
  sha256 "1af3b29a19439d2cb70eeff9589b5ea0ef9b8fa8522be4ad7b4972e5a0794883"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "018aa5d3d51497657bd376715501a8d7b378b8bbe8a3b3f5071ee890841fd7f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5dca6fb3c93f51e2d953bb91f398e73e1e88ffac0617c3cc075df20a49a3db8"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e8110b2120ea86fcb160853359c401e536a1062bac0a9a34036bc16d659fe0"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c3b30c278e151b2a9ba1f8305b17f46fc72e533c26cac97134407313bbee95c"
    sha256 cellar: :any_skip_relocation, catalina:       "8d7ec2584dfaad643fcfd69b2e3d3980f7543357c3edb266dccb1929a0608da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc198f827613a173c009b46c54224c78b071e7c2bcaea3f798b946993cfc0e5"
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
