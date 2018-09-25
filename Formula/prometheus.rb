class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.4.2.tar.gz"
  sha256 "5e327347490410f6c5491971b8e24ac02cf19fdd787354bd0bab90ea89421b76"

  bottle do
    cellar :any_skip_relocation
    sha256 "073475ed791ef15559b7a1d20cd05e00161c90bd57171898a3126099ba64c70f" => :mojave
    sha256 "f9bb6ce3a5c91193ec71f6523ce3d6267d15ce398d3816b0ffcc0403f81a8dd5" => :high_sierra
    sha256 "6872f9fc44cb9c1ef523e77f0079242d93fc9d91da1fc459eaff1d46b8aa3bd8" => :sierra
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
