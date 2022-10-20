class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.39.1.tar.gz"
  sha256 "30cb4c738220087e1c06bff045cbe82e550a474096d8416274d7130a4d5f1130"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbbad1eaa77893d587beab911ecc4ad0073bda9b399843b3c19f8841b1d0c753"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d192f2c057509b39b5b5095534f1baf8436b12dec4bcfef2e2f298f9cbe6daf"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0a752a5925d6ce62ddf228a1ba7b50a00449697b8d02bf7b56391700ec87ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d9680caeb01539bb9f3df9c7f674add588c9a69f03083e8c8c3a27c3ccd33d6"
    sha256 cellar: :any_skip_relocation, catalina:       "c4e8d27f85c24d102a332c5b1ea9bb8b52852da4da92d93d480797dcdd4867e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c200749569fb40e63c5015bc377df1aedee3b13bbfaf5f2da23b2557da024d5"
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
