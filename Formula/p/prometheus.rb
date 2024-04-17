class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.51.2.tar.gz"
  sha256 "3b9f554ac1dd90289563c9107b441736117387de746f44607717af004931a4ff"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2d736822cc8aae2b4bbe34dbdf4aae14800b5eac055265724787acd95248440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15f1e31cb7849ab043ac76a67e6eb55c72606aee2b712c982553a0d39e1cedd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a78ff3c05a423f2b5b96a88c43c6e07b59f919db5275b1f1dee849f1609e81c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "016b90baf0d5a2bd97a2a2893a5d5ab380725c4dbe7c5b8de3bd7c708138361d"
    sha256 cellar: :any_skip_relocation, ventura:        "e53fc86dacaaec7b174875e417e8d9a6c7e8d4efdba1347b1d993e7032d710d6"
    sha256 cellar: :any_skip_relocation, monterey:       "af9b72a76654d49679594399dfe7405fba774ea00b948e83d3cd270cf079296f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df4942f1bb42ab3e3f3c5e3f9a8523dd0269b992903527c2f683570f004746e"
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
