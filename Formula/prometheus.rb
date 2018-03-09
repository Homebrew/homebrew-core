class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.2.0.tar.gz"
  sha256 "e1e8eee7e3d0b1844b00f9bc06a63012284b9a82a094476be82551ef45e6d818"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9ee5b022c62f57f07fc0e6beea33bcc1b5a8c21e65a5991093219fbcb3ba53c" => :high_sierra
    sha256 "039f2098e144fec4c0f862627633c846ad3dd3691f4afba53fd6fc361ef03e20" => :sierra
    sha256 "f9570427fa5e09e34c0c99ec0ffbdd71376cb561d80fc1402e7d9f8fca501ff5" => :el_capitan
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
