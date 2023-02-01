class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.42.0.tar.gz"
  sha256 "6bf05a61ae9c4c5853b3c17063e13230263cbc81dbafaf849b8ba220943bdbff"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ac2ef9a4ee810eb25f25dd7731ef07ba138a1d48dd35df9937645189490ee6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61fcad2b0adc5a7257b1c63968b990dd1495fc262beb15a51ce5975ae384784f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71474e9f903359096740a49482de06295f6f09014421902f68a25efe351605bc"
    sha256 cellar: :any_skip_relocation, ventura:        "3a1d2a408ccce4a6fa3dfd4d7e287ee70fb472e41bfc641f0394e46f11840754"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a6dc71c4f3274e93efdbea27387a2db906da23404e6c3ce1041594226b7327"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9e10d75da42a93ff00965a9ea289f3aa054524a28de4152e4ced3734431508b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07ef36c3273e6a87cabfe7870c2e8056d8edca3e02c1af04b47f18e2e3d2d0f4"
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
