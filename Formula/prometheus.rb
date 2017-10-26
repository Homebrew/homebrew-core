class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.8.1.tar.gz"
  sha256 "dc2b7bb5b5f1273c131921d3e306fd198f2a5547abc58dcf511b700c62963595"

  bottle do
    cellar :any_skip_relocation
    sha256 "70d9869fcd13dfabdc0c97a1fa317607ad61d8d0637cf3a03abf58cdd8761b2f" => :high_sierra
    sha256 "e0a2295cbe3307973eebbffd409be1fd74bc952d6dd21b63470f0778e868ede5" => :sierra
    sha256 "6ceb4c2ed497b36cfb684f67615c5b4195e2b019a702b4e8498a2b5edd1b600a" => :el_capitan
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
      # Saving the per-job HTTP in-progress request count as a new set of time series:
        job:http_inprogress_requests:sum = sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check-rules", testpath/"rules.example"
  end
end
