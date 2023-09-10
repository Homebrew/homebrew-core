class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.0.tar.gz"
  sha256 "47b678408239019d85ad0d9ace5bd12304d2d315dec308a9b665ab34feef813a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58e1988321193170f7c4c32d2f3228c37c8c4aa117375c2ce8043d2c3f6c7c24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5f749fc68c6fcf9d2670b075d4a25cb8aeb9973ccf4878b5f5a007a14186054"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f832b5f3293a0b2f2525201452ed85e4259cfef2750e4da5208b7d64ae4a636e"
    sha256 cellar: :any_skip_relocation, ventura:        "6d2bb64c4b78a256399a0a2a0a6e62dc1256ad2c54e34682508ac6e4f0cefc22"
    sha256 cellar: :any_skip_relocation, monterey:       "9456d8ff7f3f4e10251630113882d2f020c366f0ea78c813c9dd765dc42b010c"
    sha256 cellar: :any_skip_relocation, big_sur:        "726abd0b0e1b2bdbaad78e0788cf95af478e7e3364cd389a99338c545120975b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d14aef665c602b01500e377054f257ac7b7766cf9c6ecd8221f1fc4906b5fd"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
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
