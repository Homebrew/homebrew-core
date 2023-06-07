class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.44.0.tar.gz"
  sha256 "cbaaa0e17a355abc4a90d4ead952620aa1bca8fad4a95fd81ac68c0d963add26"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c834396b0ba0b8c1584c54478225952eb3ca65b38cac415b3f681da5e7469cc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6fdeb30bd88406d6ad964eaa29407ca4c8377a2d09735b6a79669590f10fad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8402885394a1037d3982214dd482cb243889ce3cdb813c155b8835adbd90f74"
    sha256 cellar: :any_skip_relocation, ventura:        "c96d32be7696c2ccdc47c01b399a9fca7842dc57decfd9dfabe2d34e9937e1bd"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd8b41e6e1c3c03f68932b857f414d5eea6787aedb955e9c7c32366e744de1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "45fcb95227c9dc82bffaf586529867cf625174f5a66a73039a42a17acde1275c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b3c32017a9a46c1d2d1c584404851ad6281d2b82a9ead200f9268b5dcc7436"
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
