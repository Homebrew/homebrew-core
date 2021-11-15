class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.31.1.tar.gz"
  sha256 "869a8be315721115be628f766ec3ff71aa50f1a027cee776ea54d7ba070a5026"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f5703657b49c2f3e4b90bd6fe47921386cc6f9360d7d092564e877c44f9258e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f727d9ffcaa74c371d893635550229c24ee71faf0dbe6982a94cb6e064c4f80e"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6dd4581a6f6b48bbb4bb827013d1ad2e9c9d62ee9ae948b49fe8e1496cfe27"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3e6f30242f6a82d6bfd45dcaf5e545be4598d25ea9ed0406f1fdef71b915d58"
    sha256 cellar: :any_skip_relocation, catalina:       "451a4aa54b431ff81b1f0da3166a6a660f67a0ef95e1801907856a353885b2bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "817cd8df03fadf69b53cedd8e357927babb0c5938c9efbe1f1a2772312f630b8"
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
