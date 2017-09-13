class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.7.1.tar.gz"
  sha256 "209832310f5bef99faef3beaaa95263612a4d0126ca512c4a4c23a8543d3ccf5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b83caa2dfdff93b154bdfe11667e78471aa3adbf365274ebaad1107994c8be87" => :sierra
    sha256 "6f70ab8290d94ef8fa5157785eb50ed40ac2862a3df0efbfc6ea9520ce24fa3f" => :el_capitan
    sha256 "5a11d4f99784cd3ad2b1dc154b0404b53d39f8bb6ca302de6283657b8e14dd53" => :yosemite
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
