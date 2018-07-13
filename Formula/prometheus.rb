class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v2.3.2.tar.gz"
  sha256 "008282497e2e85de6fb17a698dfdae4a942026f623d8a9d45b911a765442cb58"

  bottle do
    cellar :any_skip_relocation
    sha256 "f30ef792dac595abd47e370f682b79553228262d9d72e42691276a5fec632ddb" => :high_sierra
    sha256 "a7fecc519361e3e31e6876c8280dda8df2c51ebe5435c886416620d1a529d5ee" => :sierra
    sha256 "60529dfb3b1b053f77371dc80809912210dda363a7eec4260c4ed5926746fa2a" => :el_capitan
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
