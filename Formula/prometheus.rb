class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.6.1.tar.gz"
  sha256 "ecc9ce94fce45994c23b76eb0c5acbb1b942513be601872c8cd74d0821450c5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ee791e0ea34699d06fad6f7fc9c5a0818419f676068a60594e57ab61e24b5d" => :sierra
    sha256 "d1b31f1a47e4060080bb60e437fb2da5c57d47c8ff33ed3044227f69b578a5f6" => :el_capitan
    sha256 "4698e09916579c759c6e5284129f7887765fbc39485a158c366b7da2d55e5fa2" => :yosemite
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
