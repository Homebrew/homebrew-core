class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.4.tar.gz"
  sha256 "2031e47e36d48ae908e3b1d9a13ee336ca0b1a052c693b0231dfa277b78c7557"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "852a0512909bdc84bf7b0fe77cd6e99a88f3b7ae48a47f3e8eca39e02918b81b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44dbcef1ca8cf82b32746d38e311778525754cdbb4458194c69f62722182d2b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce8634c033673c379568241cfdaad334e8ade545096fc44e4b308b64a6024abf"
    sha256 cellar: :any_skip_relocation, ventura:        "0789c58e02e8ebc48ecb07894f6be3fe16eaf302738e1b19ddd6300441f19b5a"
    sha256 cellar: :any_skip_relocation, monterey:       "a549fd9bbe10c352c055532f1b29a92c07660a73f746a2a47ee25cf26c481d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d4c9908e1a066a793d7e9fcef390265b8802e42633ebce33439b836e415c191"
    sha256 cellar: :any_skip_relocation, catalina:       "95b2d50c1d612c0d24416916b5440b504fb07f9647e499a794d7bc50b1c76f77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad4c65db4e4f584a649328c3afe8412445057873d3f1e031ec52686575533779"
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
