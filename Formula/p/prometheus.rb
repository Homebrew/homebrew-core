class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.11.3.tar.gz"
  sha256 "37bb17f10ec8c36be21452b2efbbc51fc2a94c3d75569c02b8ea0c8cf8ffcfb0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23713a26bc2fb34460d556e6b46098cf683552c9bc4c7ef11f215c576f5f9812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9118cef9b8038389071a2c980e9894fd32a64e0e7f863e75f64aa7ff254dad32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2c85cf0e76ce8215abee115d411f49ed46d960139f385cd480259a98abd3e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64708753fb75cdc0ee2d2a86c34901d344d09dd31f868d38d8694e377708dda8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "675117a717cabd54f3cecbf54e55f6d55e3441ccb4c81f4c5f5df0a1a31a6e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bebcaa3bbb33ab816705b04b49c2da72947f7414ff89451053c80683fafb3e21"
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
