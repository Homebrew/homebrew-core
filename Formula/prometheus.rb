class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.33.0.tar.gz"
  sha256 "94f16f724f032589072d8165710aa5027ae1bdb665614b4660e49bb802b3d27b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2da8d783d05e4e5747289ab85e03ba104efd944c2205113f3e211a041ecb3ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6aabd5d8fce6cfd8e4993c1d3962cc28c15bf504e2b5d15dfa1882052bd0c18"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7511960d6e31d29610541f7576fea0447c1e87823f721def9013b82909444a"
    sha256 cellar: :any_skip_relocation, big_sur:        "feaa8cd328cd3bb0963210c5ff7c04f3514c5f62b85ddaa865e03bd282a8186c"
    sha256 cellar: :any_skip_relocation, catalina:       "359648b684df6c69d400c19bb6677cb9672f0ede9431c0ae7ed400e4dfc802c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c911afb894ec9f4acdb094091fb049549ebee050fea96a9e98c0f4507b18bec4"
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
