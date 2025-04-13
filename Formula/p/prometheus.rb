class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "9e6308f48077b93daed1a39650784fc02805a518632b9c5b00e9c778ef88eac5"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3594b19d99f83ab85e35178bb8f9d3603efd473270881bf70d1b3273ce3a54fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "471f086febbd80b85f1b14fc561ddf6acc88021072e8be89a4d04b6fae9e0ae0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c0230e0ea47123db2b3907d07a08a9418472420d51728d9b038587c0afbea61"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a31e3756ddebe6d334cb94eb9fdb52a27a0255c4b55315fa79299a4189e8a16"
    sha256 cellar: :any_skip_relocation, ventura:       "22bc949812ba979d02882ad516bb94a3283357b363a34c2741849c930f9d6a73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "981465ba5d0ba54483a405edbf30f04be25bb64e5380d54009a09cd097d01b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c51ea49a42091295b4d1d19bc0d6a54fb720863ccd91f3f38922c84d5285d9d"
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
