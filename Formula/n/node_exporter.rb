class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "6a2dc6b0be27fa089574f2c32cee3673bbf4c6749c84f1d08f8c374e0908c0ad"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c5f109e08561b233b8385d58efb43b4d7a82fabfd1a048e26f1e5352ad099ce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b685328531229f921e0d39e362cae52daf6b8f168f1f8dfac81f5400b5d95567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd0852819c7539fe0381613dd8d124134f41be08db582b69266478be3c93519e"
    sha256 cellar: :any_skip_relocation, sonoma:         "97d526b98077240fca0a593964a38364067e8976697e3afde2f27d2992deff77"
    sha256 cellar: :any_skip_relocation, ventura:        "f432f7c5b2bf150090a1947e65276b00c4825621d96f510187dbfab4d74f0d49"
    sha256 cellar: :any_skip_relocation, monterey:       "ddaa1d0f23ddf6dd5781e473dc2ebc9005dd2df4996f928f74a32ed7f07fb86e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a00d48bbcb714214d82ae69b79612587881d2eb7ec819cff1dde392238c706a"
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
