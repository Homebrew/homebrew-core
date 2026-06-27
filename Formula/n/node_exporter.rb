class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "d2b5a7740b7526543429b41a5d741bc530277f406f7b121fc64cb3ca583f7387"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d948b78c2421e07943ed291d48c763f6c1101018651f977c4fc24cafa018fec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16e5df568574e4545c085a4158511f4b2b1d0bead68210a62e16565ca0d602a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7280ed9bd7d83c9205421459f2f462664f6512b29194ad01a639b4e7b76b73a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa2331dd0c6c725ace1b027b61009803698caf442f6612e686aecd27f25f3c8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c156048f29121e32978e067f9c1e18a76b9bd1b446d033a52110b32ab32cf8cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83cf562ab7570c1b71093a20723b505b7285c16dd2ed803336efba9053cd1499"
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

    spawn bin/"node_exporter"
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
