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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f221086f0c4d0faf31f467605f6ac41e9111836a1e2c0411c7452c30f45b378"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e314e1b9ea5776a9a985db9dcab4bdf28e184b57f14c8e40d7b71062bfce3e44"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37234e077521900645ffcec0585ad20637d8849fa7b2fc49c32fba8782f4c87a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db269f3eb33791698f3cc0ec9be4caa50e13de7586b863ad7b192c3bed04dc60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbf70540445b072f8d6ac83d0720e656dea7b8ccd97eb5c0ef5e4f109e97345e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba514952afa5b376f711f35be1ee2ba1b6532824771e762c0c59d5d83a6033ba"
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
