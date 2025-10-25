class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "aeb88ad980fd87ee08b1b3e5c70977c32065115cc8152e3fc846e2d60b2a662f"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0848e4d7adc854ed3d26d3f52d32255997cb41d080599648c3ba7ebd83aab294"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9df98bd52a3be5a27f2c4f340dc382f29d56a8a0cf648255717bb1ac2982946b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f080910c8d4c9c21a603f73a086445b0c654ef9ddcd32f9bb3ad09f307557c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5e1d5f2750fc4494548d5187bceeb14b1a38e62850cf4260333d62c13ad7c3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b1357008167fc4a3ca18363ffc1f95ff434211dec2541ce99d1c6364014eb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4875d2c595df32583c2078ac7894cd79bff91d53e17f96d44339b2dda66b1ba"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    touch etc/"node_exporter.args"

    (bin/"node_exporter_brew_services").write <<~BASH
      #!/bin/bash
      exec #{bin}/node_exporter $(<#{etc}/node_exporter.args)
    BASH
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
