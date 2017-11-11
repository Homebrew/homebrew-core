class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.0.0.tar.gz"
  sha256 "6947ae9b2d414d49304034a2635f0e1ecd45ac83a4f4592ea5bcca40d6f7951b"

  bottle do
    cellar :any_skip_relocation
    sha256 "731aa1f90c43b93c31741c61c9b08b15b029071aa313e7cad7b5ae1f7b6bb933" => :high_sierra
    sha256 "a2aa039b2c59c6b6086e508af0ba9e079e4ce5649dcfea4f94e1276fc9f2f11b" => :sierra
    sha256 "85a0e86e1db83ed586af1a87539773dbf50de86abec8cd9212b4c26025410f1d" => :el_capitan
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
    (testpath/"rules.example").write <<~EOS
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
