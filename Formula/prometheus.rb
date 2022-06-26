class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.36.2.tar.gz"
  sha256 "68386d347b61806565c448b48c78ff349893f26f63c0abd04a786da743dd15db"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d492c8f85c880a96996aafad9a7750d65aff4d5bf79666b8ae90599794063f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b115a9bf71a5710d8e1a9e387f8e2c437a018472259e311c6b07d19e73b8d5b"
    sha256 cellar: :any_skip_relocation, monterey:       "00378fb38c58df307e3fc69db5e190cd2cc4b2fb452a838fc40ace744751d17f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9ae86cc377846b1af06f18c624906d265cc719bb0f8c980d893b182873385fc"
    sha256 cellar: :any_skip_relocation, catalina:       "746b6de48a8894b0920a5380117e9a37eee6475630173cfb8c7cc88aadfca45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77b36bde911d04b01ef5a5884a55e2bdb07a6aa4429b43757e00e4970b358aac"
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
