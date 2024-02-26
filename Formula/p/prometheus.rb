class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "7bd134cd7d51457d07ca31da0ee9c310d6f2e1ac19c90f80f1f39169a3d786c6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0206ea0db5ce009a61e09e226a12e1dd8f6b975a7058fdb56c0d47ac7ad968b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "049f2f1815b84d0696bfcfcd54e9d0349a84953f3ce15107dd26e8171f3971b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25caf5e84d967d5b346c4d7b961711dab6177e44f8d88290cf674c7dca22675b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c7bbd5dbcf3cbc5883ada16dcc2ca8fd9e01eccbda3dbda1fbd434eb737ae973"
    sha256 cellar: :any_skip_relocation, ventura:        "2215080d4217fce1e65a001548f5c173ff32b0cb8ae5be32b98c4ebc7cc1d11a"
    sha256 cellar: :any_skip_relocation, monterey:       "fc01f6ef83eab93cd9f7cff42e98badc88954b575e94298de013fb64ab097edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21ee4b4ac240506bc8157a46b9634121946ae28aca554bfa81c4aeff953f829a"
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
