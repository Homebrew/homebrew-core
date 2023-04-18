class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.5.0.tar.gz"
  sha256 "67c6d59359d8c484e1e28d0a52a971eebe687f083c5fbb35c5e651543e5d0ea4"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b186c09bf34900911bb0bc4940707d6a38b1c7a0e61fb86a5415f49ff5c4cc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f2e08c7b6c4f46771d29e41d348eb620849952059b5e4c136aa905f2af9190a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01294c514574959a1b0f61cf5531f6cccab03735def7e29e870b7f3d274c6f94"
    sha256 cellar: :any_skip_relocation, ventura:        "e5635c6e92beda5e1e4f85396c97a0f1bfc56e9b656e0822ef87fe8baed7a0d1"
    sha256 cellar: :any_skip_relocation, monterey:       "08b62862b6ff824d79fec85055012836edd688b80cde6c496cc6f2277775ddde"
    sha256 cellar: :any_skip_relocation, big_sur:        "7af3cb9e5fc4191af71c794708751e3c245e61235f9895b8c2c09f3fee819a25"
    sha256 cellar: :any_skip_relocation, catalina:       "7f8660b470247bc23fcb352ef896bc44d8b7662aa1bc033fbee74630471dcd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5197ff118cb8674acf45da1357c73a81a1659de45f9acb9fcd5e070900614588"
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
