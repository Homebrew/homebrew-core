class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.11.2.tar.gz"
  sha256 "673982ed2394b1a89fa0250ce848fa55c05ce22f989c9de58fe9cd257175abb4"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e57131b9ac8441888149068e04afaacb2a6474cb1cd0afe440fd2dbf0f0b5d07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b0138c7a34f5c129a8a7dafd2130492ce846e8822bc55ef3b6dc4d98955ead"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcaca8bc54e9e9edd9cd395da80e4294fbdd7f32f5b9c2880c74a3594f8dc568"
    sha256 cellar: :any_skip_relocation, sonoma:        "259b9846fa2ca745f150f78a043d455481d500708ae725ef9cc2faed20cda11a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d3d7ee8d67b4808daecb485f9f4bc59af439848c925f32821c6dbdf722ae22d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50ec4db4f2ec8bd255c9b34776aad60697220836e02adb8a84129281fffc1c00"
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
