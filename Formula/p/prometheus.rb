class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.47.1.tar.gz"
  sha256 "2fbbdd907453d7448114e55d6074dbdfb046410ee21e03b937ab51287c4384fa"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db6ef0a0ac1df9e59d08ef00b7bf29b933c21615b0cb2b60a699b044f7021965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547eb23b77128941becd9a881772b2c0d3b8531a82e42b6e442c596f6699cb16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65787a9dab96730a818387b2c484c51fce6fdb13d12c23072235f3fdfa226436"
    sha256 cellar: :any_skip_relocation, sonoma:         "911b6b790efd3c0f7b167063b889ad730e1cf175beb8b8e0a422f1970d130a05"
    sha256 cellar: :any_skip_relocation, ventura:        "f7f8ec72504d162e3719c3fb6caa7742371b90e0e66843dd1ae3dc4f7861dbf5"
    sha256 cellar: :any_skip_relocation, monterey:       "76e413dfd066c969c300e13ed4c3ca5b0a982d24d14dd65daf68fd25d408db4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7104647eaaeb8f1f376983d683316f714f3ab24900b28e9b7e94859f99330412"
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
