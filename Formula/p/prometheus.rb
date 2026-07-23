class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.13.1.tar.gz"
  sha256 "84109edc0eaa0ade4f9d3b96fa826cd3112a0b2f17262c1f8338a58fb9fc7b52"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22023207639afdb9152b0867e4b7dffc075db586068cbcb127e8eda1f89e6775"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26d908a02432032783401f678309e8e887e79bafd6a2922382e0ac75969d4ae0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2830d75dbc7c88a2f8bf533a5b72de6500b533c0f63b3b9bf902aa9544d0f915"
    sha256 cellar: :any_skip_relocation, sonoma:        "2428c3e9cd5d1d1ccdb3b22464bbab72eb4ddd8475f188b0217cc6211d306ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3533472464a26ccb369d675346f9654d275617b35c4898cdef293884131cb607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6471d3d7a7abbeed0d6545148137ec8fec4ccdfe55d8fb2e7367905c2701684c"
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
