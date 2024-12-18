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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b09ea5136fdc983c35342f5fad8effd89bf72d7f318806a3276e3d8ba963410c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e4e06a647449884c73243a06fb5db7b537d65ee664364778b67b8574831491"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4589b83614ab474adcaf301cf1010d5325cd9f3c95bf57dc26bee067681e4731"
    sha256 cellar: :any_skip_relocation, sonoma:        "424210074eced05f63b9a5d3f2639800f7a611fc7a2735298e391fcb56b478ae"
    sha256 cellar: :any_skip_relocation, ventura:       "75972c4e26d62249ab4d52419fcaa14cb3c915bbe18fbdce5f29bf45be5c09e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6768376b1b284b6bd7525c1da4a4c67de9cedd446407ec8c7bd48315935a21fb"
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
