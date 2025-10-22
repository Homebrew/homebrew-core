class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "fdd446baa3b187589f3827ec443252311927c5f519482adcd97216b2f0e2b3a7"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b10928c939a0dae6b50ea6de8149864514e451edfaad0fd81f7bbfcaf4e2e19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48eae38433f81cd25f33bd43dd0e8b282de056568b7b7f68f1459ff5b65a7bc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e79feb46de18d5b1d92e8d18ceda234c7b4308c2142a90e9f2d936c23a0791fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "026c3dbbebb0c242b9e747bed650a11da2703164356dde033a14d80e8feca864"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "beda45134d501bca0d1b8b91f0ac611cfcee68381e2f74809b403929ce0581f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d7c21a7180a7e25b5fd92b2e78697a34a6d943f6d7e0fb23f8a1b5f55d49ea5"
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
