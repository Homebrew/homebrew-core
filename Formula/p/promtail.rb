class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "584d7f45cc85f884e8eb7e8ed8c35eacd2157c6edd0f2a2d0161ba39d22b86ae"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a18ca8d85e8eff9655dc09ba314f177301a053c60375411482e1d43471201f81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38540001bdb70e65b5b285332e7a2d0db6b903f583ab1329c123f657226bfd48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89e9e892ce8e374ce1cfeff3d75076a1fdc8c3bc5fee5fd8c15c5bab0c369917"
    sha256 cellar: :any_skip_relocation, sonoma:        "9674fba5c336a8b684856ccbf9d21fbc3d6acbd072f35611d929312e3d60543e"
    sha256 cellar: :any_skip_relocation, ventura:       "ecbe3543e0d56f289e46f6c25edaf01591878d4cf4ff2f9428e0016a4195741c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0807b22381049e32bc05990e02c663abac6f3d48446d55ae736480232734a627"
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
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
