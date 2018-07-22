class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.3.2.tar.gz"
  sha256 "008282497e2e85de6fb17a698dfdae4a942026f623d8a9d45b911a765442cb58"

  bottle do
    cellar :any_skip_relocation
    sha256 "3729fe6120d56ce18200fb1b8a5bc0b9b26b031275f99048f1fe31804940c425" => :high_sierra
    sha256 "be785f4c574cdca771f7bf4ab90ff918e2cd790d955e1739b8b07d7738c4498b" => :sierra
    sha256 "55e9d54ca3eaec382258f9801cbe9d079f2676cade961c4526b2722af055434d" => :el_capitan
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
