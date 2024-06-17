class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.52.0.tar.gz"
  sha256 "cdbc5245e7b54b1e247a082866b4ca73b676f0485ea14e596dda25719b22dacc"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "554d107ff141b62f020c33220cf4a8100731e7643e3131196ed50957199ef88b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bfb89052527393b3a89b47ebbec226b807ad0dfada64d366beffcf3005fbcf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "869b072d217bcdc3608de10f570021e1363e55d13d659ca56246336891bff375"
    sha256 cellar: :any_skip_relocation, sonoma:         "92546871f0435921a2cd58f5e07b2ff6ed2f04c34c36d3531ac7f6fc1e87e5d3"
    sha256 cellar: :any_skip_relocation, ventura:        "d63776c1c86cc1a24b88b28c20979584ec5673febdee7274dd64f182b13d7ff2"
    sha256 cellar: :any_skip_relocation, monterey:       "c3259f8032ca89fc34a2fb74621c7df4d50a641428b6fa6d7927aabe2d744b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "631a479305dab1de62b5a106cde87b2a2b586e8b8bdd45ae97fc9bb01e7c57b7"
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
