class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.49.1.tar.gz"
  sha256 "985d7f45ed3d16e23a30eae490c17911518fae96cba0245d493eb07097a10b3b"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3bb1bfa635debcbcbf25d94b5f47164ef5b77196cc83a2a0292646306b429b1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "261ac9bcf36828a99ffe7f0ab004cfd2bc897beb99fa5b8a2b18739a181ee218"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "173efaa3d547275d5d5bffd3baf5e6026ae64de1ba847d4a33685be0230bfcbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "224df481c99019b435b5dc86b9bbadb73281d6327c87f4ad54bead77cae180a5"
    sha256 cellar: :any_skip_relocation, ventura:        "dee352f2deef862dff57a254049859095fc6e682fe702cc8f190c6aedf8543b7"
    sha256 cellar: :any_skip_relocation, monterey:       "192cc54672e4651b472a708c0e3ca01fb659210f4a7af5b5cfb59a34596b8451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "872734edee3183ab63d4202cc0968d880636e99e375d18d04d8e492b0933ac54"
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
