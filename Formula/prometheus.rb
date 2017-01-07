class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.4.1.tar.gz"
  sha256 "9665fa6fd64442be5f68b78b8e69a4a7904876989bf76f9ec39315d7292b7fa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc3138959925393cb8d58f299b1c63e24d1fa0eba82b196aa15233ed9bb6469" => :sierra
    sha256 "cebb2f1668e90823d8a3ae3cc6bf04d176d664f7a59c71381c3459868dfd4aed" => :el_capitan
    sha256 "3eb42b95c0d019e18a787733c81cdf92adc7d7f896a91bee572465edd26fd148" => :yosemite
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
