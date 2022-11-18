class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.2.tar.gz"
  sha256 "8ea5a21b09d550a5dd5613214224ea2b38d5c7502fb0d2e46dd82f6a2ce3ab44"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "084cb8e67f91e7dee2afdf2cb34e9bea8d7c2e85cd5eb91a3f0d20422977c158"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b54f0ab4277b6de19b559257e6f923577c9c560f7ab3b0107b3b8cf7ebd483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3064f208eb0b97f33b3da2cd2c9c2da828ed928276f186b7a8a8b5870004b5f7"
    sha256 cellar: :any_skip_relocation, monterey:       "83516f83f8b272796fae54140718a6b12e524741f64108ca38082f56b475f345"
    sha256 cellar: :any_skip_relocation, big_sur:        "e9de51ea26bf17f4c5bbc41dd7aabf1a98b04ae114e422cc266004eaf49c7f15"
    sha256 cellar: :any_skip_relocation, catalina:       "ee0fd2084acc86f409f12c0ccf6bd142a16fc3443b734fe3ea1f5e9592215793"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940d9db0b4e5ee1143a860bb9c6edc029bb9cd693560058593a7f369877200b3"
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
