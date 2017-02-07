class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.5.1.tar.gz"
  sha256 "5b8e61edc6b192a5b036fb1e76edcfc8948dbb1bfb05669fab49fdbb37349991"

  bottle do
    sha256 "ca709d33e3c20d09b1a75158ab29cac3f6a46ca5084fc56c1ac622ccc5fbc929" => :sierra
    sha256 "67dbba840acb600ab053000cda4f45ff0a041e90c2d1058a5d5b571c5dc8b022" => :el_capitan
    sha256 "ae0f5151da7aa5dc8d0039cbd68f6ddf799ea0d6a3d5d716543896566a8f7ea4" => :yosemite
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
