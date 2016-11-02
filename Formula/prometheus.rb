class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.3.0.tar.gz"
  sha256 "df8845515085b5babf308ac871d6e939a51a8f2a865eb4dd5a058af99a7d0f5c"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c8d178194677229b56e307d3c6d25fd85e8223dda8bc9bffc61b96f4312979a" => :sierra
    sha256 "b5a58b4ac036501eacd98ba0153c82d2ef3246fdb20c80306b92431ec33c990e" => :el_capitan
    sha256 "c25e5ee1c56f1e34b4cc45e55bb63918d2e6f8a7227f292f6d13281105e40288" => :yosemite
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
