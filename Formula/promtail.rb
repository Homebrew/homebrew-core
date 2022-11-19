class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.0.tar.gz"
  sha256 "fcdf692b117bd412e4b5a61811d92f18b3a02db6e3802e6abec0c4f584d31861"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72405beaf8da0920a7ec457399c05a429500d39a16c9eb7848834b1a6d9db232"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "308f7a625a0030b41da73107d014bcb6fa06eb0fc622acd5b59516dcb7eba624"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fff5ff3352d377ae1c5e060e4c8de70cc99550ca2c3760bc8d8ce4b386e484c7"
    sha256 cellar: :any_skip_relocation, ventura:        "2fe783022f1142757f6b31e576101758ad7a562e776581a7a8174cd88da622d7"
    sha256 cellar: :any_skip_relocation, monterey:       "09d867a7c80ad831641baca63427f52ddbf5099c518d27f82fe4e30143cd5c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "64c82d755c70ecd27f4ffa092ea2871da8b3dacfad83c14b2d8327c59c5b643b"
    sha256 cellar: :any_skip_relocation, catalina:       "02ce2d299cf73dd8f57a0cd7e8ca7ab8f65a082adbbb0bec381b5575ef0a3c84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b37b2c66c0b27e0739a745f70445ed15b74216fcf11be60b7147f01da9fb2800"
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
