class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f9ca9e52f4d9125cc31f9a593aba6a46ed6464c9cd99b2be4e35192a0ab4a76e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0404357ee56f32794cbf864a79fba5604604a3112fbde2d333c0e53651f1f558"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83f28f43533504d5bca696669cb9bc917bbefd0bedc57647ed36ab026174c6c4"
    sha256 cellar: :any_skip_relocation, monterey:       "df17ea4a5a9e254cd6a1b5e90a46e364ee6247fcefe8b3bf67344a9851a95ba4"
    sha256 cellar: :any_skip_relocation, big_sur:        "25ed5ea88b75328f8b2c5133c818b304db617aa0f40e541dbb7b2af7103019f4"
    sha256 cellar: :any_skip_relocation, catalina:       "5727ca3af9611e1d5b98808c3f71f6854965de97b3ab5ebee0c796d9b191b124"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78231035a114c603adbe37b031766fe239d3c83dbc34abdefa329d44530a2243"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
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
