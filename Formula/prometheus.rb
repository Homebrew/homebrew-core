class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.3.1.tar.gz"
  sha256 "6463369891cc9e748e1025a600bc948e95f276830c58b44689165d5d8de7f5f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "41a64447a53eef3713f373885c270a49873821618cb1c0a334380a4ab710258b" => :sierra
    sha256 "6241c24a2048649e98339ce8832157ebd41758fca87fb5dea3262855335c2eeb" => :el_capitan
    sha256 "cd2d34a6dab1156782eac62c0e2aba4684921745170d89b398644b3b139545cd" => :yosemite
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
