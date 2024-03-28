class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.51.0.tar.gz"
  sha256 "1ca93d4397a0624b6a199a51227cbfbf93bb6eb3abd436410e6a920e5382480e"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54c08ef3a16b08b9874e52661c5d3a1d3476a322b55e02c87fba8c0c3f2df9dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21e0cb954b2553d4ee44fb95233918a28b3f5e931d1923545d26ce5b4b58b6bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214fe4fa5079f46164e4fb04a6428068a51c053fa1f878a26d90c63b8d4c9ea7"
    sha256 cellar: :any_skip_relocation, sonoma:         "c740324e9ddf679efe8d6c6c8e56dca9cae5f824feadd2b806dee9f865a45f62"
    sha256 cellar: :any_skip_relocation, ventura:        "e0bf5b65226ed19f35251735056826b0c27c14d72b3c33a3d921130fdf0101ca"
    sha256 cellar: :any_skip_relocation, monterey:       "d9051225a2e40ae4c79a6742f0d904a474b62a983d8ccde9cec4e76c394e8a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6512e3065713448504cc82b5708e822ff27b841f1c1145fa4a7c724cee9a89a"
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
