class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "2d4a71efb7c662f265c7af5f7db3367b2a7d3981fdc8860103909148b9a82846"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1530554821070f6a0a8113caca211ed5f9ebf575505786bd22125d73a7758b74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede17aaaaa817827a0b151e73fae139cd252d3b9d804ac701aab4b0d66605359"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d325517ee5b7166fc029cb1e8ca5a208dfeb210ecdee80f7de63a474d2a773ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e432e017596f207db19b748643b10583bfc3ab20a1230bf569386c9d5727b78"
    sha256 cellar: :any_skip_relocation, ventura:       "69f858faddcadb7fb651cba924423dee8bc2f73dcbdd56a5d5ac96d29058e7b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "393241c19c2222cdbc853c703a902fa685684f8e3bd19e313b1f066291212904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590756e5c7f42fc959e922f2c4b740fadb422da6117f88c931935cf5d6eaa158"
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
