class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.1.0.tar.gz"
  sha256 "81fdf28eb3f9face3699b601d03ecfe6476bbeb2efde4f09c5aa8151044eb828"

  bottle do
    cellar :any_skip_relocation
    sha256 "560e7be5a4de81b7bba63386033ca468f8ed1a454f403a9a444a1737580060ec" => :el_capitan
    sha256 "cbfce8bb65affc075a60f9040a3a02cf9b6e16c0044f0b12d4ecf75239aa2dd0" => :yosemite
    sha256 "f230f9bb9632a0ff0040b41624aa1d13042120bf7ece51a5aba00aa67a637873" => :mavericks
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
