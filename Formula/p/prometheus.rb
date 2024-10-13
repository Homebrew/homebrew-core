class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/refs/tags/v2.54.1.tar.gz"
  sha256 "3ee88a80f82e069073028862b3c92b1938bd932b059d25b37d093a6e221090d9"
  license "Apache-2.0"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e2ec4e280ce4226174a560a7843fdf0c72a5d163d6846b2d44f28de0cb2cb87d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "567d22d22c75b829a80d19116597ac96b602848215355caad3f1d8095f9feec8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "feed8cc8398f6ea1cb80457c20385fb48be87d4941ad156bced358e7f2837fa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6820a3ce376353d61f35ba8d7d43cfdfaaf8f955dbb6a0731f967675cd9be9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "a503b60145ecb286de31a993adb021cb32e27a4c716da0754e544ff92a5848e7"
    sha256 cellar: :any_skip_relocation, ventura:        "02d412c2bbaf2b5bdb315487d5ef6c077865886135b820f7d3713c2741a87dfc"
    sha256 cellar: :any_skip_relocation, monterey:       "12e5ad99ef9337c1707f96bfa75d1a152404008f1c54d9870e41e37d7ac5f414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0969669cbd8b9a2325ed160dd06c83a0621ee93238211d6b4fa608ad3a61e6c8"
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

    system bin/"promtool", "check", "rules", testpath/"rules.example"
  end
end
