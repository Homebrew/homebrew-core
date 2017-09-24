class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.7.1.tar.gz"
  sha256 "35ea7ad02fdab688066c7e7fa67d5e5ee50ed7d2a68f3cc62988a03a154078e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "43503f2b89cc6031ae1db833be2dfedb1181e4c192a9c47dc470c2ee75d67866" => :high_sierra
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
