class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "b97651c0aa00d0f6fd2973b773b18d31fe0402a4ca75b1eba7e788d7de42c9c0"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "912173b70b3150399f3a908025f3e2edc26084ba53379281754b5135e15c8340"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "271edf8e6dcba9ec01cd3d74d3f4fc10c538d4f27f7c2c9cb3ab520f6c60be3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ae861ea386aaa6059652d19d77d6d95d3717f5016167cbe08f49ecb1fa8fc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "474ca230aee9be98d608b6e35f5ce15fa81015e723ce201263ab08e5c33e9a9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8add80594efd8cab6da21ecb39167f89930e0628f912613b444dd9be2a9573ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbcb6f3055ec10a93702d055ea58f10eaad109baeab10f83db2db2796fea9faa"
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
