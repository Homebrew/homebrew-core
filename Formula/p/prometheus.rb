class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "fd0bfdc1390e71c3eeb05532293f9e2a1279e75d3546aa86dc4881627c9e143d"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8ae1d7c8ef9553082d667e1d1f8eab772cd3827dea277b1b8fcac06adb47446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d78299d32e7f1b8756c8e2c69877ec1aab347ae5085584543eed671cae3ff220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55d3cdd9a180533618e0ed8bd5801d127d0e11bb4e2c6b6ed3653a50250461b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "aeeb206ea1b1c97043b2255e69b361bad3dfdbaf6a13b6a7b70c2d993e1530b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5d81640b9987ec8145509a24fc322a4db9cd632205d87beefe27f4cce7afb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290c71bedeae5b968be45b302869fa2c20f96695ef4e3ab81e2bda92dd11b6b9"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-tar")/"gnubin"
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "assets"
    system "make", "build"
    bin.install %w[promtool prometheus]

    (bin/"prometheus_brew_services").write <<~BASH
      #!/bin/bash
      exec #{bin}/prometheus $(<#{etc}/prometheus.args)
    BASH

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
