class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "2709a3bd43f9d15e0cecfc33ab473d011e2a69ab29265b91398cc1b8561403c0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6607be636ac1b5496110d1a21f11a0414dd60f6bd5eb29a8805d648d99dfad22"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c80ba4a82ad7082c4a28c352deed958c5fae171cd318b76e42364f288e60506"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "058b8e12bc99aac286016d3cc3c13692fdb0054163e6cf44cab9fa445c6afe44"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "343de893d9a9188419ee54039292fe4451dfac967d5b61fd3b10318d12a648e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "77b0cde2792eff4146e63ec5158068526b370268f120fec993ae6491a84c82fc"
  end

  depends_on "gnu-tar" => :build
  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  deny_network_access!

  def fetch
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"

    system "go", "mod", "download"
    # the npm-download half of `make assets`
    system "make", "ui-install"
    # `make build` bootstraps promu at build time via a network download;
    # install the pinned version into GOPATH/bin here instead
    promu_version = File.read("Makefile.common")[/^PROMU_VERSION \?= (\S+)/, 1]
    system "go", "install", "github.com/prometheus/promu@v#{promu_version}"
  end

  def install
    ENV.deparallelize
    ENV.prepend_path "PATH", formula_opt_libexec("gnu-tar")/"gnubin"
    ENV.prepend_path "PATH", formula_opt_libexec("node")/"bin"
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "ui-build"
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
