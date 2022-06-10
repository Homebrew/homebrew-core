class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.36.1.tar.gz"
  sha256 "50f1d1a6eda49f022050708a20bbc04c7410c854be2402d6706a53222417697b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605fd3eff1b2509d20a53c52b7421bd09482cd8e82c2fdfe37512a1c3c6d9f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "540ac74951c9bca5aae81446d0e396002a06855a32dffb63e05944a433562f55"
    sha256 cellar: :any_skip_relocation, monterey:       "c3f75a0fcf3ca96d46590ee30730cc4435855f4467b284689d0802a57866df01"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e7ed5dba2622ccb2fa05b92f72105440264e446b8606cebdbc558bef749941d"
    sha256 cellar: :any_skip_relocation, catalina:       "143fcb3e412b60f1f38c575b6cd8ddc19bb27c3b0726939487845199bf9bf0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30ad2a4cf08393943558e518e7cc303cc5f6cbc5742e75b6784ce05f77269cbd"
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
