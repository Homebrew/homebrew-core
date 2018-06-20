class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.3.1.tar.gz"
  sha256 "3aab85d3cb59540b6b43f5a80b14d13937fc0d51e8e82a29f0efebf6addd5f75"

  bottle do
    cellar :any_skip_relocation
    sha256 "b12062ff9caba1c556041307911a403015344708714dde1479afa9f19fb1c414" => :high_sierra
    sha256 "f435a6d5d211360fcbfc6d2c8315bc58738b7303aec26d88c4882aa922b71035" => :sierra
    sha256 "df951a8c4b633b40ef917329d67db15bd3b757f8c3194ff1983ff3aff4594d24" => :el_capitan
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
