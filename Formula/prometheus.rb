class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/0.18.0.tar.gz"
  sha256 "4def1a9e72acb6ea360e246b34e69cf21888be5c7e1bdbf29a3ab9f244e6e0aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "36f80a0c687ef757018c6b95d604811bcaa91a1e1f0eeec480008307e2e07d01" => :el_capitan
    sha256 "8f04497b96d27acbb6a3621390483064f27fe7f828cfc6cdb4940e198985bebc" => :yosemite
    sha256 "0ca3e9013e9098b3790a9a3d3aec191cb2650816072b0dca4e424f332f84bbb9" => :mavericks
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
