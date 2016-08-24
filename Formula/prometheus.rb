class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.0.2.tar.gz"
  sha256 "f20c001728d92eb5b745023e43102593095a5a9eb500be77aa4e28cc90f8db72"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d1d28dc7aa1fd29196ffd23586d246137a9c18fe5ed02399d097cbac5067d10" => :el_capitan
    sha256 "02ebf83deb15208f675142c59703d30ad9f2295bbc394d3250f9cb45c28dd277" => :yosemite
    sha256 "7b0cc4b5fecdf061bb7573e86dedce819eef5d4bc440b1e3c1d96365a0ff70c4" => :mavericks
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
