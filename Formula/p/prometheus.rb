class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.54.0.tar.gz"
  sha256 "e1c3676d0cc20d6b493fd7132f524ce0b17354339ada2d113956bfb2919fd2f2"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0d40f5b0d3bc1cf49309de248a915c47b1881b454c1a0f3482294e552df4434"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f29c44f80fd10a88846e0eeb2c6a55c3df622680530630762a097ed553d8d13a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af76d2eebba522c29df95fee7479b77b15f6b1b5db2baea6156c4f4606286d5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "feb1f645d14c30d6bca6cba7e3a77134878d8e2d6c1f1d38200adbf009e4082b"
    sha256 cellar: :any_skip_relocation, ventura:        "c4b4a106122ea5114894bf32110b423dec1bc5857000db7378e90ed80d797c7a"
    sha256 cellar: :any_skip_relocation, monterey:       "8abf1caf6e11d69bd94e072aabc6c899728f8873c85dab21a181956c7f957a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "543cda6b5b7fc1d3f6a54e47ed31d7068d93e8c0d4a8713d1d7f8413d00ef784"
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

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
