class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.7.1.tar.gz"
  sha256 "209832310f5bef99faef3beaaa95263612a4d0126ca512c4a4c23a8543d3ccf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "7fed79b9676caadb002cf56e22055d1c513b244888e393ee0ecc89a9543a62ee" => :sierra
    sha256 "60c8f39e3b88e9d11c834e022c43ca4596fbffd487ca7825b7aa989a04f4dad1" => :el_capitan
    sha256 "331da14abbe801b5fa3014779b4cb9bb4dfb8d3a639cc5a0fe0627d3927c1190" => :yosemite
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
