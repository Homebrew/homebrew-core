class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.33.0.tar.gz"
  sha256 "94f16f724f032589072d8165710aa5027ae1bdb665614b4660e49bb802b3d27b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d271c78f3275762c40d37c274091609081a97cf8e9b6aa12f64933dd77398944"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "298fca009f864df152b6be7115bab6d6cbec7c7ca9134813fddbc3f94135504d"
    sha256 cellar: :any_skip_relocation, monterey:       "21d77a6ab7bab2be48468b4d7f48e92072fd945ceef672273f5cd83ed8c8ba0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1bd0c386daf6de30ffbdbaf4725857f53c033324558277cf8176a2784931fbf"
    sha256 cellar: :any_skip_relocation, catalina:       "f80d7c53f08a3f1d9fd908708340d9cb362c181c873d28c759d26d91208d8d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97edc1e8344f610aacc86dd6022f7db8fe23120546cf328676b01cc6a7f24008"
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
