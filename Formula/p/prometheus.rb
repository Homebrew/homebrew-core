class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "6601dd9457700f86d9d328388d68cdab82c6a93948621befe5391e67a09dc499"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4cf40d744a79d8df867ef86d9d372ba25b9a106bc8ca12c5c2a6cf79679565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9960f517ee5490581c78fc5f774518e3dd77f3517dfafdba588d5647d6875a8d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10f0d1cf8cb9f0d080ae1ac0e5d5ad1f73f0e7ddffe9e63da0e5cda255f32576"
    sha256 cellar: :any_skip_relocation, sonoma:        "4faf8df2f235d71caa11c60ff270ce615ca2bff9eb8b1f6b0898a094409daa50"
    sha256 cellar: :any_skip_relocation, ventura:       "b8e6634cbcd0d50c90cbfcd291ba63247b2285f0d07fe03c39103987692265f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15becf1ac1b6eb68ab86952e64474c5e1531da1c2da37b590e5c6cf55e8fe643"
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
