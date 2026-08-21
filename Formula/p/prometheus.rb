class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "9294e72722fe8f90e54994ce36f331ea6176cb0edc4149cbf1d023bc89536505"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87d6ff48eedc9d3f9f87fe4fdc3df9852ee113bb99fe3cf793905ae6b573f745"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1e8b7a8d860aa2f54c5a3d63b02db1f3ad8ad8a8fa513aa0bd9da4067a8e54a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "869c5564471fe3ee5fc50a1323020c876244052a4b184cf9c57c5c70a5bc5c7c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef5739b94eb9a598a188d524d70dee4e00ba131f2b43e7cd4f7b40c7c4d400ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b828dfb7f4400352c40977e6aa8e3d968b5ca583e4a3e3139a9a2c39f57e9148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a4b8e5c2cd98194824e15365aff7fd8c3a18e687cb03ddab2ace8237ff511f8"
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
