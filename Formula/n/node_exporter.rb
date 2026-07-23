class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "a90f1df0fde58d216d4a7d342e64831d2e3257db8084deadbe69754d34b15142"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4940755a005ca7e51e11f28709882b3aa036e8bea5d07e4ef902a76875b66a57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb74943f82def0f2e07826688c81fd41842eb4c04c829eed2283018dba2896e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49702b39916ec9566f96af09e314ed665d7b8775e1c88b4ff3b355644d5b7747"
    sha256 cellar: :any_skip_relocation, sonoma:        "102f85b6b16a7c8db65a1a48a09a950b09032f6ca3814b0429b9107164406b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e11b10c9859df2b2fc18648e22b6805997fe7b57cee6ec27e2e6a8dfddcf48c"
    sha256 cellar: :any,                 x86_64_linux:  "e7868f24e2c501f07cfca37d27f881174460ec00574a9378167f6cdb95de710a"
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
