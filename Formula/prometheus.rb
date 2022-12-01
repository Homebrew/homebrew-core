class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.5.tar.gz"
  sha256 "b28692e625b6d9b00676bab7251ae23f4bebdf060df55c6e2ea3eea89a5f01a5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ac73d342231a8abb5748d29a278e415b3c97d8387d11a8b860ac32cac56580f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d107cffaaf1b45504e430e7555dde4a64fa5b9b2b89946d0430af10bd0571051"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61072661cf52de569e42f85e04da81274de489e33946582c0a887e2bdfd84ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb9d038c2518a72bdb1b4e46d1fcbb5c4e3d845efdf782dbadbeb6e0388ac65"
    sha256 cellar: :any_skip_relocation, monterey:       "2256bd1ab469c076fb71af75d9487ada5ec8f6a05eccca93523795cd9b2cfa12"
    sha256 cellar: :any_skip_relocation, big_sur:        "16fad8419696d8ce7d4233902b7612f8963b936a7d369c94e71295f6fdfc64f3"
    sha256 cellar: :any_skip_relocation, catalina:       "128f85a284ff5286ebd8934bd61b23134b5ca62516dc041eeb8a65cc6874495c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d2db875f4454331b40d6606235bf126fdfe42a0bf73ee36748725239e83b6eb"
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
