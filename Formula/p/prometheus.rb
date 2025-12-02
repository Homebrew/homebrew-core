class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.7.3.tar.gz"
  sha256 "c3f6be8b3198d547c548dc6289f06688c245b46dcc28490e60445b06e5360347"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c66eb74bd4067f6221cbfc4736953cdc4094cf2a013b6e74d3f70f25b56eaa3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb2a66b2d841010db0b71cae9e3096fb78bc6c10cc6d0444e0ad9e93de4aeb03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ad404c46d44d3bd77d0fcc85b08899793722b675bfa396dedc37602d273e922"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe3ced7cc9fcdfe836160ba8446ff261029d73415663678ffe440d834d61133"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84b0e404edfde54ec6c7594a85db7a7efcb8f9eeb4481d04a45c873846c23ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cbcf42ef5e5dc75549cae1b9ac96758d0faa204993bbcd745985332cdce3ee8"
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
