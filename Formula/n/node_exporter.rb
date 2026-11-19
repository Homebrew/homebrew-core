class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "329f02a71a0bb007e7e700f12ff724b019415730fb60bdf724bf2b28f3d5f223"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "702964d827c7ca970e073f3e0681c3e1b902f785067e3df0bdc826d7485c6a26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "13b1fdde02ad167e31075517222295e2848dff26061d2041f27abab36e6fa5c2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edeaa3b350ca40d43b40aede00fca2b4e64b4e2f9b9564470f2b95b49b3ff7f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21621fdb8ec128caaefbcd1b303674b6f5a2db77f9ab052e7b690169e30b1d4b"
    sha256 cellar: :any,                 x86_64_linux:      "6bc742cb499be0f77c3ed1a6c810fb1e84836baae8ee8a674bbde8f1b93ec329"
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
