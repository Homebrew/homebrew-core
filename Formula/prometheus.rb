class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.28.1.tar.gz"
  sha256 "6500dfe91f8d1ef8e7c064262a66773c2ac90d59a3dc9e3e480bbb29a78a3574"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2d5ac471baa2ae32c717fd29732fa000f2f9b4f1e7a8bfd46bf00ac5858215a"
    sha256 cellar: :any_skip_relocation, big_sur:       "02059fadfd4236bb66937e2c0ed85efc157cedce2eec67c164ec3b9b57b0a3ef"
    sha256 cellar: :any_skip_relocation, catalina:      "5f5dc533678eb06fb57f0b54bd7b635ce9f0532c2a7e847bf81cc358936e8d79"
    sha256 cellar: :any_skip_relocation, mojave:        "28b262ada92adfcace530fb58c03842788028e499604e47e3c6223cb16e516ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a3244f2b72c88e1e57eb557950dc0d70b9baf84405555470943e1238cfb5af7"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
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
