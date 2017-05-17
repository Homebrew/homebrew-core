class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.6.2.tar.gz"
  sha256 "026fd958ae3792938613675f455131e954552471d15df971251b46e64ca50b35"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f36cf449319bfa609e6a1bb0e80c9050bd6b153728e7b295d09711ac5247cf8" => :sierra
    sha256 "52f6571b2a2fe4d302354ffa90f098aa54aa7a4bff0d6877ba1f6580e99e03ab" => :el_capitan
    sha256 "e1e38737e483561f605747a96bfeabfc93bc927bf884f9a02b7e8e44ec954b9e" => :yosemite
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
