class Prometheus < Formula
  desc "Service monitoring system and time series database"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/prometheus/archive/v1.0.1.tar.gz"
  sha256 "b1a74b77d71521ac5439eccc1eec97b0106c350d9bf6f02d694bd40142ab0620"

  bottle do
    cellar :any_skip_relocation
    sha256 "0847327c35dfddcd0c4a2d6c3e14fb81ed3e6b688c61a011915c6ef20b377770" => :el_capitan
    sha256 "9b922b98bf15522e0d26a0f5c43f7275a2eed7c60399db8d2398e8c268c2c044" => :yosemite
    sha256 "affeb9eb6485eece9fa4fbf079346458eee83c6dfa92381d2d9d6c78e94d96c5" => :mavericks
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
