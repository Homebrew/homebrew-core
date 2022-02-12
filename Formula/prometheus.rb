class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.33.3.tar.gz"
  sha256 "8ad9f25fb1faf8528015154ef8fa6ebb8851a6fd19f0085e6e1e677325f972e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b937c31019a3bc68bc037e7ec13f0bd6fdd7e656e557234eb11a440ab1e8813c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca4aba895e28de88950474c5188ee244d8fb4b87532e272c28ee996d3ad05da9"
    sha256 cellar: :any_skip_relocation, monterey:       "25add7764b9a365a6f9b73c96201d7c8fb93642a05c372956640c7b8a714d9a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3af21cde5b8a34fd3b225efc7b31a0b2a1eb7c08c4346011cbafdb59e0d9f3f6"
    sha256 cellar: :any_skip_relocation, catalina:       "34d57fdadd30c61f2488a6e2ca0368cd73e82123c06ca55627b4dbf549ca4425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "130a9318bdf6e2f528b7653d3ce5a82ac49556301587e592d481242740c7fb5f"
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
