class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.2.1.tar.gz"
  sha256 "4f75427449bb72d1886f6cd46f752fe6300242da48b8bb870dbbd7ffc879ed92"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa682ec246d2db9e3ab9be9b2c3defe6bef8a63908fe3e63d8bbc07e403e3765" => :high_sierra
    sha256 "aee1c55052a8ee88739d81a7c2c32b2c8567844bd5f26ffa2d28aedebdc57e73" => :sierra
    sha256 "0f38b166fd1d62f79abd53e5c258d5364bf742c332c4eaf2cd1f034df84b3f25" => :el_capitan
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
