class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.4.tar.gz"
  sha256 "d594cb86866e2edeeeb6b962c4da3d1052ad9f586b666947eb381a9402338802"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4c8d010a1f423016202da40c38d8b57bb710b0af20fd2a4051b10467e2683d44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c8d010a1f423016202da40c38d8b57bb710b0af20fd2a4051b10467e2683d44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c8d010a1f423016202da40c38d8b57bb710b0af20fd2a4051b10467e2683d44"
    sha256 cellar: :any_skip_relocation, ventura:        "fd88a80d942578aca5d2754a27ad5a8af22cdc8d34a85b2cb22f0ea54b2ff7b8"
    sha256 cellar: :any_skip_relocation, monterey:       "fd88a80d942578aca5d2754a27ad5a8af22cdc8d34a85b2cb22f0ea54b2ff7b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd88a80d942578aca5d2754a27ad5a8af22cdc8d34a85b2cb22f0ea54b2ff7b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4de44de9ada199e7927dd267a2e8d1ad488ed43385274ccc60856c5470cd63"
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
