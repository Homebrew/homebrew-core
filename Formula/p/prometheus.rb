class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.4.2.tar.gz"
  sha256 "242fa5c91f41edf6cd68fea1c6cd896f0bf3ae577a45c33ea9af3643dcc71766"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2677b1eca6ed5feaf9eb847304026ba514df6434bd5131badc1ead028167ace7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cf41af0d602b9f9837ef9f3c3f25a0676aac4413e43f0ecd05ab6939d07adef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5edc9d1bc553b0edf6c778a8925733ab4993d1d1e6718078fbc53b9fdbaf4ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "583ca75f3903e73e2c1ed581782e99846ecb815de62378795cabcf3ae4d736f6"
    sha256 cellar: :any_skip_relocation, ventura:       "51fc075f84b6aac23d2ed627d0f9a0e28af7e2aaf457e4e497abc254d84a23f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afdfcef44ffca2e316bedd987acde7ec0b1a0db3291da69de176ac10c19484b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30320efff769505d7d3db9251fe228a55f9ed38b18412a719163a23cd934fb05"
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

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~YAML
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    YAML
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
    (testpath/"rules.example").write <<~YAML
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    YAML

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
