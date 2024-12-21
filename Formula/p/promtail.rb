class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "dd2e80ee40b981aaa414f528a76ab218931e5a53d50540e8fb9659f9e2446f43"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c327a20a092e22b436044f7d2f52f0c64e08deeba519f907773b9231bd4b65b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13489ec35a2bf94c582823eaf9a44f3dd82c01285ab744c7bedd035d981b8866"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "804f580bfa400f674bce4e4b4d766b1ed7fbc2909078016e585c600ea311d10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "779b37392f462f360d333f4495e517d7123d8622b41094f3becf8f242eff21c9"
    sha256 cellar: :any_skip_relocation, ventura:       "6f8b25b6ff9c30a47604f35b109220dae432eefb9389c989abaee3c23ae6bfbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1164b17aa1229aba3f930a40f3d7210c0fa2ba0a08fba0d57dcf972bc8e7f687"
  end

  depends_on "go" => :build

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
