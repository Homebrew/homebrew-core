class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "fd62e16b49c55300314f3b74bd736d9d151a62a1ab075258786c7aeeee94e48e"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2b6a36223a6673fec2ce4a2dfd40695530809c60bea7297c79ad71c1a4a1ae0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "667c122319ea8873649ec2b99f65b9396da9f5478019590228243d093c8c94cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1692d3b357e78bc4eafc8c0e20c099de21dbccb65e028bba67865510a44dd28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f448dd8d1c3bc76001eb0b49d6d2517929984dbb26ac3514c61b6c960679edf8"
    sha256 cellar: :any,                 x86_64_linux:      "1962f7253b4bd5b55ccb3dbb3411807e90583261d7c26ed35acc0ee0e921f7da"
  end

  depends_on "go" => :build

  # `test do` block runs a local exporter server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
