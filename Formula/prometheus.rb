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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f110357d5fe8668d5240fad3c986519be4fc35b96b5a03c4ef11544714d3ccfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a247ba6fff2272f2046b387de588c3b0236ecea7cd359f284a0c63635097572"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d8c4f8da0a83675718a5180f5a6f520ce232a2c16abfdba90ece2421a1f2f3e"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5f7056d9b65f8268188d7bbd4f256d1d3066eee0c36a0db9fb05d7c2d11ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb07493b18510a814a45ee3ba022adde7c209df43f6db8995318ac5e8ca2885"
    sha256 cellar: :any_skip_relocation, big_sur:        "27d33d0bab5700216aa17e930eb4a3b2422459f213e0d397a5e1a484bf690a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6031e1c15a1f67c63cb2818a6253ce885ed3b3318ca1f9d6c5588af90892631b"
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
