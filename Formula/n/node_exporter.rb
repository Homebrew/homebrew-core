class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "ac80b13ced462e88f243ad5e98c12bbcee2628bf552c0d19bb5ae125ce09730d"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565cd465b106577cc18e06dd38849171c6b2d21bbb52b77bde2acd62ba410507"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92d7ecfaab3f175f5456d0139ee7dca60226d7fe709c64f3442b5f7c3430aa73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1055c3e3d6071109e65dbe6035fa09d895235cacbe20e089a4c2e8f5053b05b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "97088503f43c259232260ae0b5795c6cae1c1d304e3dcb9b3b648995c5a3a744"
    sha256 cellar: :any_skip_relocation, ventura:       "0b9f53c0e755e2d7c01b325303647106c54f96a60a90f552b6c13c6bbbaa1a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d866c49ec2dd77096b45308bb18d209f81545bdff34b3309f97d6b43ae42dc5"
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
