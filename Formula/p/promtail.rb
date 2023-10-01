class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.9.1.tar.gz"
  sha256 "60c30c9d6ac2e8f7eab6917684c9c843a638cd3d3f31755f9d0ec8c6839a8196"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2790f80ff31a3ab5acb032dba035e7a75f2377db18269775d9fb4754d2c6df6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9268b59716b0c656d826510a4a2d5fb294bcdaeeacf5cb3578221fbd3532b079"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3f586a9b0499ebad655f8ad228ced12919f4b1f9698fa20f38e40b89a9f8096"
    sha256 cellar: :any_skip_relocation, ventura:        "1cfd4946877beb98a7fbbbb45f84af676f8ed9ec270e234ffca235e3273f3b54"
    sha256 cellar: :any_skip_relocation, monterey:       "3c935af30b8e85fa885b4d7a9ef72aeee2a6cdbafb641301cb4b098b02b5f113"
    sha256 cellar: :any_skip_relocation, big_sur:        "23254e5d8d758ae7241ac01b9ecb505eeddff2be682cc64e7e7082c0974bd481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6168e213144ea1c5087478f8d159dcbe9614267161090ef2fc2fb44ae1f82ca"
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
