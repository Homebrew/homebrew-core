class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.47.2.tar.gz"
  sha256 "931ebdbddd78f45ee9de85fc42466c72a9b77136ed8f2a914f3f04a77725d9d6"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b1e38b360a0ada9ab0a5d01554f06f80b8195f962f5bcb187e66d0f3682e548"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a51ae31b931912c82deb007d0b0e0ce38bd0daed2301d223781a9dffe2688174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88cc0be06e7fcceb6f482cb4176383633917ebae98190d94a04d551caf00ab73"
    sha256 cellar: :any_skip_relocation, sonoma:         "dea1ea3107f8e7845b4a7b37d4a86e088078ef5bf4da2bcefb3641ce0f0c1cde"
    sha256 cellar: :any_skip_relocation, ventura:        "97c12a6f736d924ccbcc9fc3d78fbafd85fd00edaa6ce9dc5ef335d3871d31c5"
    sha256 cellar: :any_skip_relocation, monterey:       "f789985410db252b32fa0a79bbeb87d580ee05a1a6402a5da31e876428e45219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36c226224b047417d5dca73039569bbee80f7e94c31ed4d7ad90744f7ca2e1f2"
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
