class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.46.0.tar.gz"
  sha256 "1b01b087a61318f32239345c9cc02a79a163418fe5eab63041754e4fb5db787d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cdacfae60493c042563567d5ad87794f66eb152d3b4cf07e4cc1e012ce3fb833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6cfb188dca460b9b54d3f9adc65c9f34936d3d34a549e4eb93daad6136ddab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c64c3473264d5d9bafa3b196ffc6abe412e82994478c48bf231b76bfe887c86d"
    sha256 cellar: :any_skip_relocation, ventura:        "8d52e9962c1dbd344e8f190facc808b17eba37974a7c7ae7d4d24b8ea4d88bb0"
    sha256 cellar: :any_skip_relocation, monterey:       "36e183c008c6e36cc870392933febffe192ddd48f9dd87d70b4678029376def0"
    sha256 cellar: :any_skip_relocation, big_sur:        "720fb12ebc71f3b64a2194f6d66f1474f31a6c349ceb808111e8aec24ad85fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "421a712506a8aeacf35ecfdedd20cd9f8fb5ec25a8eefe83f9309a86a39f960f"
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
