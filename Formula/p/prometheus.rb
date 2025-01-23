class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "b23aefb9e0018788ea048fd1c0dbac945c4acf7b20a6ab0cf81bd3e717a2995f"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "947f0a584dd5b449ba14b9dbe2b45518d2d3df59f687a6368a80426b714de924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "144fce0d0453379f0ff60feac8477d04f47716a3cbd082f759add60f275e6e4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e62cc21834406c8ed534ef35f6b68d30a6ca39bc282eafa6aab845f9711b2f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6f6e28e8adca76e985c1cbb737b8a7d97c1fbd8e37a90ebb7f769629831a493"
    sha256 cellar: :any_skip_relocation, ventura:       "136fc4aa18543501079282325c6f415a38c0e068eb5227b31e3222d236744399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd911046dcea4710e125e22534b323e6cf7498e194e32b1541458e3d0aca5da3"
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
