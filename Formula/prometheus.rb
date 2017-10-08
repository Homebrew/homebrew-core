class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.8.0.tar.gz"
  sha256 "556247d750b3618b74ccf59669f74a8c0c39e72cdf51cbcc0c0bcc392de195df"

  bottle do
    cellar :any_skip_relocation
    sha256 "daeddc9407750936da5070a0247476b429718a40ab05fa64abf3739b79e67fec" => :high_sierra
    sha256 "32569d9345e301f252f1b236d165c2dac7fceb2d1adeeb29762d93aca47201f1" => :sierra
    sha256 "65a2d50f6ef9af5397eff9f8fcb541a8f8b224cea618926cbce76806875ca033" => :el_capitan
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
    (testpath/"rules.example").write <<-EOS.undent
    # Saving the per-job HTTP in-progress request count as a new set of time series:
      job:http_inprogress_requests:sum = sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check-rules", testpath/"rules.example"
  end
end
