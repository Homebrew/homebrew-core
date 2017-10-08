class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.8.0.tar.gz"
  sha256 "556247d750b3618b74ccf59669f74a8c0c39e72cdf51cbcc0c0bcc392de195df"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ea86d2ee61bbebcbace5019cb149b8e17cbcf427d3150b9a916e9a50f38df7e" => :high_sierra
    sha256 "b1e2a6ac69eada09853f4535d010453eec92add29c8eae92ce616818a7ea6b83" => :sierra
    sha256 "142c03dd9d5e401e99de6719adc69c164bd3ef56d0db87ab53ab6ec30b8b9466" => :el_capitan
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
