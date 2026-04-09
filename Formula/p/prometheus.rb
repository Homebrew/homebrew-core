class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.11.1.tar.gz"
  sha256 "8832e2fed21f3945ba93659de35a4f3c4e170201b579d96a94f3dd69a9c7410b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d9c911911faed5918872a1d8a15cd58db3708de5dcedd9a67473716b22340a74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "817e457af9448cffae693cd940a35fb8d523bda8f8e54cf76906f963031da115"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44d890bf94b0fe75b56ed2424a27125dd48bb2ef2fceffb276579b3af0a66f57"
    sha256 cellar: :any_skip_relocation, sonoma:        "3462dfee20acd8693e79530736f945e95dd7fcb85e62f55aa25f36bf0981c127"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b557b6b2c0f21ff27b9fe905d4fcfebcfd64b306e065fe386b7d011120f4165a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0afd1e71357b5154ac561278505317c31d9298d3571f4f08f4cb442272b809"
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
