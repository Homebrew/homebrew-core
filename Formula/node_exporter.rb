class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.4.0.tar.gz"
  sha256 "96f749928e3d6c952221aaca852d4c38545eaae03adc6bb925745bc3f2f827ca"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b46a6ed45b8ee93d3cdf0f4ca9e516beb6747b54e54f5232789961760a3d9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "217f1bb2d38c3e052eeb6499da88a64eae85b30b06da5ed57218701c06d4bb63"
    sha256 cellar: :any_skip_relocation, monterey:       "c09790655a6c6a7be2e4854d6568d7a10e78f40737c5be3a3e3a638185f98231"
    sha256 cellar: :any_skip_relocation, big_sur:        "a66d6ee73ea9a507d9a9b53cfc00e704aea5ab25afbdc54a122bf427ce6205ee"
    sha256 cellar: :any_skip_relocation, catalina:       "144b9ac75c49b768320604dd8ebdb0434b69f3dd3d449b905090ea03fbb4e2c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf38fa04f9aa42cf1bdc7010cf41a64553f94d4b228356a94f54b5958a8b2e8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

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
