class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.4.1.tar.gz"
  sha256 "9665fa6fd64442be5f68b78b8e69a4a7904876989bf76f9ec39315d7292b7fa2"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a49baef03f04332878708a0f4b31cc697957c1365063c5122b8a6290b4d7140" => :sierra
    sha256 "7ed8c29d2aba50517a01c52a85438224445eb549a3535e58b93c2e80a8903e00" => :el_capitan
    sha256 "c6273e092389dd89e9eaeafd4840d721ba8e4f906148a69d4014d4c99ade52c3" => :yosemite
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
