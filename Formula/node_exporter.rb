class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.3.1.tar.gz"
  sha256 "66856b6b8953e094c46d7dd5aabd32801375cf4d13d9fe388e320cbaeaff573a"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e99e508cef6d2a24256e593f93b74e2963ad1cc7e5c2afd00a5b8c2ac8ba58d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfba63c91460b85b51c1ca10677b201c07660c1b707dc8ab3c43512dbd86ed34"
    sha256 cellar: :any_skip_relocation, monterey:       "fe501d109da5207288495fff1bdb82c38b5d3d4cdf7f2ecfa9a2752f8af1c8c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6258be13386a4e8808db92a0a0f7d993abbd28d3cf73ffba6ad34ddaacee867d"
    sha256 cellar: :any_skip_relocation, catalina:       "5778761dad16f4f576128aaa00c021a127e01cd8a76314d7d1ec277ed083822d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6f7e18658d6272d00d15335fc02d9c8a3e521868cb20a7a5aaca68d7e4aa23"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/prometheus/common/version.Version=#{version}
      -X github.com/prometheus/common/version.BuildUser=Homebrew
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"node_exporter"
    prefix.install_metafiles

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
