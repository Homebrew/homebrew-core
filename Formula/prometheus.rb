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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8247582dd35d3ec90c12c3f3d405c14357650b4c896eb13895bebe1d9754375b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca890a4ed114d57446288512e247870310815916523484272c22a52b019c1ef0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3ac805e33b0499a8ba4693b148fadaff48cde29e61150fbc125a6f032f3c948"
    sha256 cellar: :any_skip_relocation, ventura:        "93f55ac2bd183df33485a10ab18a99e8bd22a418ed3026dc61371ecae1246415"
    sha256 cellar: :any_skip_relocation, monterey:       "a90dc0a2ac06b83fb6d9d3522f9b4f660eaa024396d16acb50854b4b26e4e05f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a38bdf930bd72ea612a3cb49eabebc97afeca13fadb192b1b8194122e40b93a6"
    sha256 cellar: :any_skip_relocation, catalina:       "4fa5b049412a452731f7688a4d678c0a778733d366cf220ebf65821c9f6dadf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69fea3cd5bb1cedb091e60aa14345d0a7f225c8c4c3972138fa111deab1aa385"
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
