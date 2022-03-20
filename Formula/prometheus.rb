class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.34.0.tar.gz"
  sha256 "76bb5afff1a9be179b99afe624fae73d5c23a27976f2bcb2dc663d1942e87e22"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae862e0dd8ca43e833717b393b88944c5b6d36d3c05d737364b4ca8f23fb9aac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "491f0e82bcf3042d2e776515646e05d1ed115bd8f754ffad7e5891ef4cbc8909"
    sha256 cellar: :any_skip_relocation, monterey:       "86bbf44a53b8475915031171090257bf3894a3f65a16e54b0cc86976f1e4c236"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ebfb0dbf6449e17ceb7db548a1f98f4fdbcad50b1f09850a1687b4c695c08f3"
    sha256 cellar: :any_skip_relocation, catalina:       "712c4f66fcbe179d770ecc74b8d7f1ffa84bccb7e3c4e949a1a3f81ef34ee083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584036bab89255f6541ab6c61b19961981651b04f36386fbe65903b3b7aeef72"
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
