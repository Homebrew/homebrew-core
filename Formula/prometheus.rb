class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.43.0.tar.gz"
  sha256 "0cd8860e5f10d0ecb35d20d23252ddc459e8319882dc163bf71b723e3bcafd71"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af971614a062fdd6e5a9f3b72477d199522bb1c7531921a018acd504ab18c4f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0649127cf1ca0038ae83049bc2d63f155c1713feacde4a6f48188e0c9f99b42b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f11d353ab23c7f033846fc7e58437fed3f6993e2fe737e5a635e1d9d0d1f033d"
    sha256 cellar: :any_skip_relocation, ventura:        "2f38d9ac1df8770c2911a41221767c756454e4c3d8fb175b7279782a0f497d1e"
    sha256 cellar: :any_skip_relocation, monterey:       "5eab0076f21fde8827786d83c689070cb2a062d894a05b116a039765ff2d184b"
    sha256 cellar: :any_skip_relocation, big_sur:        "26c4a6415936c73fd01bf501f07f1cee85ca307b2c4e3ff3df4a7cc0f70f88e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1050da51cd06c701f626cfc665dcfa008517124a2a54321d978a1e7640c6ff2"
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
