class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "5562c10a41781f1378cf962a117e7d70a2cfc6e4be7f4cada2474dd534f6512a"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c923a4417f2df1f38e58be8dfea2e8b0f9947d0d7846b50390732d8507d729d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae7321b0af3160846f44c3ab19687d41e2522c480cc0d70c5db288c8b8378d22"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cce5dbab6fdcc602ad7b19d5246881340cc9c73f012dea34e5332c4b93667c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e8ffbe106b66b98fae120243391c5e7d8abbedf27829c7431afb5db44a27bf1"
    sha256 cellar: :any_skip_relocation, ventura:       "f1aa55da6ad61b4c5e9581aa9b12fd2f62ff9f0561bae140114339de0f3194f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec96e25e99f1a94c64ebc062ef48f45d860fe77cd61496447e4ab694904f0f75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cb889a756a6561ed5eadd858d266c014d4262656207e2201bf763ecc2f150dc"
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
