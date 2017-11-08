class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.0.0.tar.gz"
  sha256 "6947ae9b2d414d49304034a2635f0e1ecd45ac83a4f4592ea5bcca40d6f7951b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7bc3047615ac9ee5d8cb347cf4f50354403ec57178b74834029f05c64db93af" => :high_sierra
    sha256 "cd47034ade01eed33947a0b274961ab86a849272bb087f5f13b285d37367088f" => :sierra
    sha256 "3da21c3990e35735ca8f9c9c048319d5f297a62777b29dc9f88da6a1af3643a4" => :el_capitan
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
