class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.48.1.tar.gz"
  sha256 "59383d09f7a2a97461a7d3df4fd387d0a59229125bf52e8da2b075faa8cbdf81"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0714057396bb553f8f6bb981a82c7a17f60048677a078aec007f8a6bb3ed7697"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83b997ab01cd8b6038cc64df5fe11463e0ac2c073cb475881529c45494d1e37f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "207403ebffeedefeb25998343cd54ee2cfc39fd1b8ab48448ac878b415d0fa58"
    sha256 cellar: :any_skip_relocation, sonoma:         "284a6e482f2e579ba7522c41e3a4d11d74bd8ec137f40da322f507990195877e"
    sha256 cellar: :any_skip_relocation, ventura:        "8081a85293dee8608b7d3bd6c3d3c8b126d3600e44f943fdfb6918535740759d"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2f0a091c82e98ff0acbb75932189c9b2456d37c67e64995d6e4e066ef64e28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07ed6506156e411035b6d077cea345a66019f21d1866ea53a01cfe97940b540"
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
