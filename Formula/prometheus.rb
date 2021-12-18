class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.32.1.tar.gz"
  sha256 "36665c49bd122f76560b89500c44aae5126edd53c8b57ae126af5e1dfd262ee0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4560a38c4a7a0ade5b1959dce37537a88244ddb70b295eeb4712f99416135465"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "beab4eef85be23bca1489a298201960482bb258b377d83e4831834843e098ef3"
    sha256 cellar: :any_skip_relocation, monterey:       "2e32a6f22fc5ee2e0d00f3e04ae57b47c204c38c25fa12294f9a146034dba74d"
    sha256 cellar: :any_skip_relocation, big_sur:        "28f1dbb4808176d76e55b22e3b9d2668d3e32b8de5ffcd2a9d303d7cf7498826"
    sha256 cellar: :any_skip_relocation, catalina:       "4d53785586f1219ac6af91bd2a7c7663728436392cbc3093837ae5fd5e319ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eba1d17fe60a9a77449471f5d8f57b3a90859fd5b84b4ab7b55dee27f0a88f78"
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
