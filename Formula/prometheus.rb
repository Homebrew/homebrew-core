class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.5.0.tar.gz"
  sha256 "e1484edbb63480bc5ce75b661a328abb7b7b2c609de41e8fd0af0e6539fe02c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "23c21f308f7176c27b4c81fe9ddf53b55b2142fa10de23f895687e124f9a276d" => :mojave
    sha256 "55b96e31045bb042e49cfaded637ce51e5ebfbc5eb26c8c360dbe4aac2bbbe65" => :high_sierra
    sha256 "17c789fb8d0e88c5e9a56221cf9a1c01f58022f8d26f54c78339029228507730" => :sierra
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
