class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.1.tar.gz"
  sha256 "8b75f877445d60c86472eac77d122e0cf1f85d5f771d2a2a1a39241e6f6c5d5f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2661ec416969175bc96892ce384d4a79b54be7ae2a4d374e69f613472c9f3718"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2661ec416969175bc96892ce384d4a79b54be7ae2a4d374e69f613472c9f3718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2661ec416969175bc96892ce384d4a79b54be7ae2a4d374e69f613472c9f3718"
    sha256 cellar: :any_skip_relocation, ventura:        "569c0df2d8fff52a815d761b539bce830b636453d5663f45d3787fcd24189d10"
    sha256 cellar: :any_skip_relocation, monterey:       "569c0df2d8fff52a815d761b539bce830b636453d5663f45d3787fcd24189d10"
    sha256 cellar: :any_skip_relocation, big_sur:        "569c0df2d8fff52a815d761b539bce830b636453d5663f45d3787fcd24189d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e575a29a8ecac6e32a98750472575228c86b13c33793d4e8d53245e4fdd4190c"
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
