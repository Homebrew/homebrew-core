class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "f615c70be816550498dd6a505391dbed1a896705eff842628de13a1fa7654e8f"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d9ed4d98edbc12270f271477c94d66b2e6c42057f74d6288f7c0114cf6a8aca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "763072dec71f2cbbd34b19873574e0385258f0c2879df86e0dbbbd2408f4d32c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "310634ef8185409fd48cf7c978b6015d7bc83290da06345566699e6e7ff84adb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6046cc85d395e2d4aebda99e3bede1eab9abf07eb3a1a95c177d10c11043c94"
    sha256 cellar: :any_skip_relocation, sonoma:         "b6f5e9d5c2e07a113313c97b06243e94a1e1f3a8960f3a0818a3a2f56f3f5ab3"
    sha256 cellar: :any_skip_relocation, ventura:        "62d5151b71d60d7c7ea67a703e6b348233eeb5b3b1535cb03c7a14951ee3b846"
    sha256 cellar: :any_skip_relocation, monterey:       "0a8138efd708d76751c0c7811a28217f107dcd97a078e7ed99113dba8774ef33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8300960df12d7d8ef8b9bb30b764b2ddc61527e09c6084a5b44eef3cc581f885"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:)

    touch etc/"node_exporter.args"

    (bin/"node_exporter_brew_services").write <<~EOS
      #!/bin/bash
      exec #{bin}/node_exporter $(<#{etc}/node_exporter.args)
    EOS
  end

  def caveats
    <<~EOS
      When run from `brew services`, `node_exporter` is run from
      `node_exporter_brew_services` and uses the flags in:
        #{etc}/node_exporter.args
    EOS
  end

  service do
    run [opt_bin/"node_exporter_brew_services"]
    keep_alive false
    log_path var/"log/node_exporter.log"
    error_log_path var/"log/node_exporter.err.log"
  end

  test do
    assert_match "node_exporter", shell_output("#{bin}/node_exporter --version 2>&1")

    fork { exec bin/"node_exporter" }
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
