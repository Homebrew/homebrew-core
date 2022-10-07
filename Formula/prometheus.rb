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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "242e47e7cf662334bf0a41de0838384748eabdd8e5b16b38908df608a9725726"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f051a97d059d69af4b030cc97639310252f04649a389d4130410ea6fc7345a84"
    sha256 cellar: :any_skip_relocation, monterey:       "8236f37315287948fa0d379cc22b2398623e013fa691277eacf72bec6e6e32ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a678f6734ee1f4225eb0427db0de62096980d2f4d3afed332cfad47fc4c73ae"
    sha256 cellar: :any_skip_relocation, catalina:       "f1d205b8c4c595015e45cd02d924ddd8f0b54f23b7435853c7553f5028f43d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb1a62fe20e239585fc271914fc01bef0c0f65c59c3f3fa84022bf0bd40eecce"
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
