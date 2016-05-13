class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/0.18.0.tar.gz"
  sha256 "4def1a9e72acb6ea360e246b34e69cf21888be5c7e1bdbf29a3ab9f244e6e0aa"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5bd980c21a17cc3144c6f926630a043524473c597187a819023fe17bb1151cd" => :el_capitan
    sha256 "de08265b7154e3b4036b2dc3a02902f6fe2ad6ae570e195bd1c3852f8658b4ec" => :yosemite
    sha256 "fc21c6a2a8e36b7154308afa4215616455579fc9b83023627f05920df88d90d0" => :mavericks
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
