class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "90586300d083873125b45e25ba68ed1ef2c48202d392405732191fffd5d99d1b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec3359ff9d0cd9d2c838f67556fe13d72aba97204f9df34ab37ae2914130e349"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d930c017ddff4b8005fdd38dda62d1d87734a6b28ab422f1fd2b1a7f29fd4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70d031c99684ee11c8028261bc5f5d583ce5bedb1fd27620406276011a234d08"
    sha256 cellar: :any_skip_relocation, sonoma:        "74ee58989c57007ca1ff652f33e887e752324f952a52b3f88fe34daba7512270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6b4d34e41cb4e5b52a6d9712c97b6acd05b00200f069c03e8ece30f7f111028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689b9336ae9eda4b321ae5bdb1a8b2f28e65fd5e2afe55e01346061496437051"
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

    (bin/"prometheus_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    EOS

    (buildpath/"prometheus.args").write <<~EOS
      --config.file #{etc}/prometheus.yml
      --web.listen-address=127.0.0.1:9090
      --storage.tsdb.path #{var}/prometheus
    EOS

    (buildpath/"prometheus.yml").write <<~YAML
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: "prometheus"
          static_configs:
          - targets: ["localhost:9090"]
    YAML
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
    (testpath/"rules.example").write <<~YAML
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    YAML

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
