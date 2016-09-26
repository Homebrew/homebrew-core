class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.1.3.tar.gz"
  sha256 "6a27ddc47c90a50090fc787300fd79ae97e1fa172e0544cc1cc021f8104a64a3"

  bottle do
    cellar :any_skip_relocation
    sha256 "0be70a917b07ec467fd5718c0f8910735efd11355cd4b390473288eabeda80a6" => :sierra
    sha256 "604829efcd779b5a7bea9048d10854a7cff2ba9637a33ee8a4ef0d6aa3a9e70f" => :el_capitan
    sha256 "92efcedfbd70357a124ddd90a5903af4224c5bdc3dfd026af9e56e3e8526ce45" => :yosemite
    sha256 "aca7a6225e5bacbbd72e0897248a397200f4c9983cf8f4e0e856e3194c1da4e3" => :mavericks
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
