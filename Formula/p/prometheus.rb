class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "ca7a8dd2c57048bb952a493a2957811c6f380089c2b158c2def484b874c3b6d7"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "211d5913eab5f2450ead841fc0ffdf6b13990b436a8644d8b9207a0d171f3b0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f597c184145952fdcee826751a7eb061b67927fce91ebbeb379a5364d3e6827"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8cf852f62d5ec19dd0164e4771a54e035da91a75cd812b3ee21da734af39b44"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c91dc3830404e2df1e552b4642731e4af7c49d1b7b8924447c0a1d8d7933903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddfffca5185040aed81c65e0b11e010828333c35279dc3232170b4e448dca84f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "301750a324d259f5fd92266c581ccabdd6fde73236875aabb03408a79bb47e29"
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
