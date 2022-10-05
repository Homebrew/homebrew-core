class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.39.0.tar.gz"
  sha256 "5853a11547983ba1884af77669e41b8db02828a64789e9746dede654c039b113"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5db7e9f7a224c46e1f426b8a12ae2155ef379b1132922766ecb0a47ef5d69f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12975807f226c0a2cba9fbb3e8ca6f8809b679e375bc9d43f6044d3f906fcd82"
    sha256 cellar: :any_skip_relocation, monterey:       "44112389e0f88efb21a1bb1a61ba39e126e63142b02ec481cc8668e57a86fa37"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f22ccc97431101a502a9d70ab9d3b790df7e5ec2d77c513ede90695cf1c51dc"
    sha256 cellar: :any_skip_relocation, catalina:       "628528e7d17397d21f78255d8dafee6032f67c01f11621b985b0b326810ed5f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae11774a7b3aeb3bbe4c7f2253267e04c1761f769eacb5154fa4634f66098f79"
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
