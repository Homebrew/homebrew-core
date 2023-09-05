class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.6.1.tar.gz"
  sha256 "933d191d46be31da3fd608b97506115ab63a641a3b20c3931fd63faceb89222f"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cae73e819d8b58983cfbcb2500e406acb8846b2dfbb9d9945bf01843f699936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221dc6a72fbed73d439e58e34a5afdd1cc42880b517865c5d535873774cdde3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc32594b9b12a5285e48aab4b7a1502ca0ba4e25109ece2ee115159a37de2108"
    sha256 cellar: :any_skip_relocation, ventura:        "1f5fc236847e29a3f2eaf31fd801935a2448e5c75ae0af72fce44fb5e34e4360"
    sha256 cellar: :any_skip_relocation, monterey:       "b2bfcd925ad88c66c92b9cfa234c478ca5ac4b2b7217911f9af26dbbce3446e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "733c760bcb42a72ac6967ebcc6d3e4525bc92ad92c450772c48bfc85b2cf5b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23912fa02ab47c8c08e77e350f6ba07c168edebecce7b999e53dc5f29f55dad1"
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
