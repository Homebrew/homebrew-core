class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.5.1.tar.gz"
  sha256 "5b8e61edc6b192a5b036fb1e76edcfc8948dbb1bfb05669fab49fdbb37349991"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b3384447df1a19c4a27dcb86bb1c239c27258b829e8df86e1ac3a4e2baa6228" => :sierra
    sha256 "481bf9263754e8f42102a298ada5423a5efd221e93547d0f0c7d9299a32e86b8" => :el_capitan
    sha256 "e0f20d091bf719315e916d985287c60f9e30d9a5d2445f3f6ea2cd1f2e939c13" => :yosemite
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
