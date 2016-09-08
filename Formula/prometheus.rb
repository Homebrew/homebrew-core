class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.1.2.tar.gz"
  sha256 "1a924ce9d8880a6dbff11eefbb823cdcc0af5977488deb8e5d16a74ae68d4708"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff1af97778aaedae6e859b622ddedba37516bf219408b986d6239bf092124f2d" => :el_capitan
    sha256 "b8e9f97f52ca48dd2850a04aa03196f76b3dbb1c93917ae853092034a388a01d" => :yosemite
    sha256 "509d47fd6aebac5e8a05d7bb1839174f1395d30db6e15c7b49fcc0c79f72ddc8" => :mavericks
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
