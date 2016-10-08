class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.2.0.tar.gz"
  sha256 "96bbd13326150bc65c2d35d669f60a8fe0c447e87120d876a2101adb2a82c442"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3f04d4230e710ab524913d95fab34c1920bcf87fa8975e28ffb0952c01596c2" => :sierra
    sha256 "4319ffb9fe887e1ec3dcc5d841cff135e820268496ca2f083e3adb4629c8b8c2" => :el_capitan
    sha256 "1bf6bb86e93331641c4477b2163e13fea3e54b922f191db1b8a85a127cf6ca3f" => :yosemite
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
