class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.10.0.tar.gz"
  sha256 "a3d01efaf82edfd074f9fc48399969bcf22f22b8fb4353dfbbcc79cb2a03e579"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d8f111f6611cba09c3b048ac2a33ef15994440ed768e82915e76bdcdd3b03f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf4482b852a4013da01df287f39ed91eeee9eb3faa0b8b3a0ae0197716131267"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c9d01f7696606acbe80fcf14b5584e63ca3683011d2f8ac9ca81ca86c24fd3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "89fbbf68f6df5e3c58bcaf926c924c0c376c5678725bb29e960a0501a912c193"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29b8a559ad9677481cad28bb2be10a9b38a832ec00072039b4e0a7f28aed60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbdbc118eaa3ccad36888eebcfc4d6aa0011a2386a3c9a9637d77aa1f00a45ed"
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
