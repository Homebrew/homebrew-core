class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.6.1.tar.gz"
  sha256 "ecc9ce94fce45994c23b76eb0c5acbb1b942513be601872c8cd74d0821450c5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ba16f06b1e9c6d71a19e3bc0d1e727b0ff5e6aeadc884c13fdf3293070d7b08" => :sierra
    sha256 "b2954d2549a95c8356cde36adc0b3d632df7c237e1fd54c97e55648ae749effa" => :el_capitan
    sha256 "062d30c8d8ce9ee0f57932e34aa3bc31411942ad1401afc147472c2b6f057c87" => :yosemite
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
