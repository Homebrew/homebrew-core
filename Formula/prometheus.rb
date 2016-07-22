class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.0.1.tar.gz"
  sha256 "b1a74b77d71521ac5439eccc1eec97b0106c350d9bf6f02d694bd40142ab0620"

  bottle do
    cellar :any_skip_relocation
    sha256 "44e59b5592460259cf5aa8b57512bbcf7efefd059b10560c6ab8d089584a1882" => :el_capitan
    sha256 "5990766cdb0d6ce1a3bc178acee965fb0999b48c602d1e8b5577008112ed9b9e" => :yosemite
    sha256 "8013f093f2e9400a4884b21354237cee967378a425a39b69313600746d559ab8" => :mavericks
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
