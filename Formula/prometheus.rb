class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.45.0.tar.gz"
  sha256 "20534d4124d692e28d20b6c4699c1e8d067b009cded5c5bc17ce16b906874aa5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a50369794d932ec5edca3901914eb5e6dad010458c2d2971d3cfcbfd4323d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7f8a3385e2cff4a3df2c249e78295ed8f83e1886f537b70af9d4f0e9245a4ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "299a6c9656e7ca36cf84d8a315fd86a6973eb0f1bf22c802de1366907a988f19"
    sha256 cellar: :any_skip_relocation, ventura:        "b23d6e710d5e242e6c1b1304b39668e85fa61041c121714ec9bb470ee85fb0f5"
    sha256 cellar: :any_skip_relocation, monterey:       "478993fa5984ab3a585eac91878a0ac1508f75dbf1483fb448b2105229dfd309"
    sha256 cellar: :any_skip_relocation, big_sur:        "670cac49116fe6db3882575bc894a8098350d4007bbef6052502ebe81fafa5e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "296f66f89169f9b368d359aa18870d05cc3cae4681ed520095ab81a8e5a12422"
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
