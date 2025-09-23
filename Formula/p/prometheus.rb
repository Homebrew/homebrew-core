class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "fadb33c398026e190f9335e90e214065b012b9cb454da121e072697ad307cb47"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39c5d048d520ea92e933a44cc96015b9fdb43329d5837565d48054929957b7de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed251252de3abe10f78fcf652f10b65374a606e0150ba7a0d84a167ac3682168"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3fb611b40ababa09cb5a4ec366f424d3bfc2feb5aa6bc89be78d1b143e59f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f12cb0fa710e6cb9e62c45c0877d881a7d4cfff9bf53be6339dde39b0719789a"
    sha256 cellar: :any_skip_relocation, sonoma:        "675c8fd67a9ea892ef3be5950c3093d3eb142016bf450b000e3d14c27afb156b"
    sha256 cellar: :any_skip_relocation, ventura:       "0781e7fabb074e195462e1994b0907c039d3eb812e2c72bd38eeb972bd0a678c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc448fd655cb2c0d8525b71b1b8df02c1a3ba6b5fa75311bfefb6ff41d241f01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b8474230d9e88cb41b0782f1d71e1193de27a972cd5d576fc55390bea3e827c"
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
