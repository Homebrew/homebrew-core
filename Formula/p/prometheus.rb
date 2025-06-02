class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "2b0b5d6eec26e1fe78e351b87643f3dc78e62f8d57616b227b0257b1d87f6e0e"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a9775029feb9a28f329af5491040579b7d948d9a1d5545037914f23797079ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59d916a50973bd24609bd1dc97f3584a5eecde090a095e7661990b7e89d298a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f604c408ed36d6644ba910186ab9a2a0073fba5487fe91f55610bf00ce673129"
    sha256 cellar: :any_skip_relocation, sonoma:        "e50e575a9aab9e112f37415e5bb07d4fd04462e846a55d1dbb92c5a6915176a1"
    sha256 cellar: :any_skip_relocation, ventura:       "9e473cd5b42cfad728934d5b45458ffba75121e250e11d264c2e4db4b710a92f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d39b17ad6f6c31574869643a66e066e3fcdd0a51bde9ade9651af275f671743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13f036d41bd5016d934f34e021082722d6e4671513f685e689df078f491bfc72"
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
