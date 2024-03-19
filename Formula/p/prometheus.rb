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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77f5f7e1f2d4edcea6aba7d1909c38591bae3f5ed586a596cc98090334923847"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f4621a86d8d349052f49960f5ceff80e2498b792bfc169b099408a54566a3df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0859a5d05afe50bc72ffa618f2a229aed3a7ce436dfa3133a6f661cb31d9d1e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bcf251a98612c0692bfa053d6f6403b597e327b9c5cdbe449ee273430280a6b"
    sha256 cellar: :any_skip_relocation, ventura:        "55c39734e8bdd94f8d7c056f6b8bbfb93b9bf9ba3ea97be8f4207111e7a55dc5"
    sha256 cellar: :any_skip_relocation, monterey:       "a90ded388a1947975dfb2d0dd8c8ba64f6137e4aa8ef9fe61515341d123dff9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c838385c19464dc9e4d20310926d78601167e199c0360772100d6506f5bb2eca"
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
