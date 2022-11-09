class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.40.0.tar.gz"
  sha256 "707a4947b222eff4683e022c56975b3a8412dafdbfceccf66c6710faff9d291d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616f737f6db93d22e8a42e86fbfed0ffd7e793e9ba828cf904945b76f79b65d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0da851dd1248d32ec36085eccaa42f627b8d37a9f913dcef77119404ea2e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f225a6ecb1305acb0ff27c4876e649c4b83f0e818891e7021120f3ca444cef1"
    sha256 cellar: :any_skip_relocation, monterey:       "ffd1734eab2a79c2fe03b22a5e9e399bf6de30fe42d8e57b7364c4686d9960db"
    sha256 cellar: :any_skip_relocation, big_sur:        "19713676b07565ed11f1cdd300b2b3c897357c184896cf438837092a0024e5f8"
    sha256 cellar: :any_skip_relocation, catalina:       "05cd5524b107a738ed535638626b7d2a3b781393150df9e20df457a91673e736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4cb0dc8d5e71ec0c8866df82ce52ece1987a9c2c0f3c3a942193d0e5f8d8780"
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
