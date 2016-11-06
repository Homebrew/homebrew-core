class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.3.1.tar.gz"
  sha256 "6463369891cc9e748e1025a600bc948e95f276830c58b44689165d5d8de7f5f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "221e966a09f90ccbd452fc188f1ae65ad9775a90a7523cecc43dc52546cb7789" => :sierra
    sha256 "22fb41333099b3566a0bf2c19ba74fc4cc2cf12dbd72c9ee9dc9ed1c96e7e81d" => :el_capitan
    sha256 "321eda86a33f34eb96f70eb5853d2c259018dc1b3c4b4e992067e48add43a865" => :yosemite
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
