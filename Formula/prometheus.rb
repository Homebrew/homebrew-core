class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.6.3.tar.gz"
  sha256 "1c2d01f3a44b53be3b672cbdb1843fbe8fc135020bbfb6c71b0a10b141a474e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "d898a5e625c5b42a00d5c747979ca56da96cb81dda190064490933ddfd444940" => :sierra
    sha256 "b92ad13360aab40b848a7f698741a148c3c00fca4f04ee02dcdc26b7eb150139" => :el_capitan
    sha256 "f505af62781865693dda14147d017eed6cf2c47fca37f1c2d6fd64e0356d4fa0" => :yosemite
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
