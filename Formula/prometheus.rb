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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc6f8d082da5023a5e329eb5a7adea9899e6c6a5ee6df9b9a88c3a332c3ab1b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "941356bec6c7fbf46fd69b9811ef99ef038859480c5c903e8e5a563adbc74d27"
    sha256 cellar: :any_skip_relocation, monterey:       "a0dd08cf1f78df0127eb3c7375e021162451751ab109b517be7ae233320b7974"
    sha256 cellar: :any_skip_relocation, big_sur:        "70396cccba7c97da5abcc7c0864e2a01c068b9e776c57db1bdd671bd2fd07b63"
    sha256 cellar: :any_skip_relocation, catalina:       "17f83aa8fe20ac2d6ddba2afea84f6d2365d498de7ec53ae37a33e42b6751414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9b5bc142183ba802e87721975db35cd85e3493d8205ea5d2c710294ebfabfce"
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
