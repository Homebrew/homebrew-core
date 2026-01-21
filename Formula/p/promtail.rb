class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "99da52c3d14c7bd7e528d9e84dbf8e7261a0ef216c8af4cfaf59d173707fb283"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72aa80a154d7dd92d217376df43d1ccc32925fcaea25d44061605895545ca7fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18cfa9d700b733e0ff3343d5f421d1bcac1edc1bdf89221f78a0b532dfd38baa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56808a12406df65713247a8244416279195589bd4639419e2ddf18707e17c21d"
    sha256 cellar: :any_skip_relocation, sonoma:        "758d7fb210bd101749f89b17ef46de1ee2e6b59e4dfc11879ac5ff438022627e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8bc0d44bfb3af68a2dd0746766486dbe57405213606a62bd87ad3d4138c55ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4dcc66990d9bad002992d3a954e860a0f85e734667690f81426f5dc361fc5684"
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

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
