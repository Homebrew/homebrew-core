class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.5.0.tar.gz"
  sha256 "e1484edbb63480bc5ce75b661a328abb7b7b2c609de41e8fd0af0e6539fe02c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "394665ad8383aa39be07f711d734a0dbc0cdc43ba1065eaeda8df466dfdd2b2e" => :mojave
    sha256 "e6c9d071352de4f97c4a7905fc940b266fb6232faa722acfe7748bed64ce3c37" => :high_sierra
    sha256 "fa2803eadb0fbbfe5d127c272f345b677dfe4f7511af5302945c15d9ebde7085" => :sierra
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
      groups:
      - name: http
        rules:
        - record: job:http_inprogress_requests:sum
          expr: sum(http_inprogress_requests) by (job)
    EOS
    system "#{bin}/promtool", "check", "rules", testpath/"rules.example"
  end
end
