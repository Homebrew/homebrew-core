class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.0.0.tar.gz"
  sha256 "829055d0275b73d9a3ebaa930bb690bb080683bea5a50a911f5e07ca6c2d44e3"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d2705dc1a89735c5902cf9df8fdbcf7cd9be874c528d59b96d5a9051d71b971" => :el_capitan
    sha256 "e92c01288bef0230f97f82c02adac302f2f7d508f2bcef8f516edac99ded29f7" => :yosemite
    sha256 "fad1283f841bd5e182bbbc0f9687cbafddc7978d7aee4e1bf861eff1ab4c99c3" => :mavericks
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
