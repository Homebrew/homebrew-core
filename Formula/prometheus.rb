class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.2.0.tar.gz"
  sha256 "e1e8eee7e3d0b1844b00f9bc06a63012284b9a82a094476be82551ef45e6d818"

  bottle do
    cellar :any_skip_relocation
    sha256 "8faced338b6d2dbc10cfafa9a9f134dd1933730395cb8c6b8b74a24f5a941975" => :high_sierra
    sha256 "2975767a3d41d09006681887dd89f0b7cf1696ff90d5283436530a5a4c8f2771" => :sierra
    sha256 "efae144da3783630ff7869b115772a23a9d2596b67993b6f17b360cae308e211" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/prometheus"
    ln_sf buildpath, buildpath/"src/github.com/prometheus/prometheus"

    system "make", "build"
    bin.install %w[promtool prometheus]
    libexec.install %w[consoles console_libraries]
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
