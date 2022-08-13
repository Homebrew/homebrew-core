class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.6.1.tar.gz"
  sha256 "4b41175e552dd198bb9cae213df3c0d9ca8cacd0b673f79d26419cea7cfb2df7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f0f5960c4637bb193365ba2d99416fc2b82033ed2ec53d23a0e8e70cb9ab0c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b9545a183837e09e5000a58e31c08947ceaadba9ee5ffd968d8111005203e84"
    sha256 cellar: :any_skip_relocation, monterey:       "cf70e87ee25c1b32a10b71970aca3d3160c69d6d6f56b1bf6c2bbaa6b258a275"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc799404268114067883f8adfd87c7e9943c40fb61fe9647289aed61c323b484"
    sha256 cellar: :any_skip_relocation, catalina:       "3fe64c6da40e1cb419b858633cec6699c6574b4b7eb413b40aab9713f6df65d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04c1fb084e997340dd03a306343b114c9b59ab16e7526a2468e6c3ddeb3f7cc"
  end

  # Required latest https://pkg.go.dev/go4.org/unsafe/assume-no-moving-gc
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
