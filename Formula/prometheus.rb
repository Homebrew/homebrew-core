class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.36.1.tar.gz"
  sha256 "50f1d1a6eda49f022050708a20bbc04c7410c854be2402d6706a53222417697b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06cd0432226d8ffab86d03dd5d9ce31466a558ad038ff1516f3e41fb129109b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52fa15a292672dcd11442b38e287fc4f433b56695d9e265718042913d53ae62f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce60d66d81d7e4a7dd0112cbff3b788f3d00b1e5909eec91c768e1fd681c479"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ae0c3968779f9ea5fb3bf9e513267d8f51a0ca17731a84e7585e6a69c4aeebd"
    sha256 cellar: :any_skip_relocation, catalina:       "2fe4ff5631775315d0a01bfa0ab8088f1abfae900de7c47f633203bee95195bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4416ff92355afece0602de91b768b64c10d0b9664a2d75381a84ee4c4def0a77"
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
