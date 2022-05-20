class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.35.0.tar.gz"
  sha256 "5264a7b59f5b9e28d3c47bf694a1062e6d3745c3797d28585c2b44eb9d72da1f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69e2230385d9f26cff0d0d3f62d78114928d40dd8296b1f3af7b389f5063c2b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01c9cc609d6d820731bbe47565f19e1e354645d82f8c2a14a84909c59efd6833"
    sha256 cellar: :any_skip_relocation, monterey:       "7dcd1088a3bd046961f1d66c002d8717febaff45a9b7b196025dd432b3a625a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dda9fb7d82c90b65a51e30f22a51a52f05ef913d875a58bf5b05a100da4ee04"
    sha256 cellar: :any_skip_relocation, catalina:       "54e46b68de6d17751d015f55d202ac4d1f47629013d328848d83f9308d150b90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f20741dd19460f66fbf3999418ac08969a2080e6cb6af6b87b0fed0df1ec6844"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  def install
    ENV.deparallelize
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
