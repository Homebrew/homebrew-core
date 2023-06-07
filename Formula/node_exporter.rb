class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.6.0.tar.gz"
  sha256 "4e3e1f3f2f9a1d78c12752e055a0d0c809dcebf25c71325302fca1c759648eda"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b147c7e585c33d5ac124561ff82cacd86278adfa238d32c138688f8916686e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "433c9dd3e44684a883bb81a275c1aea1427309ba4aa2d4b267cd549552c2357e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43832f1728d22ef51cbb0e70fae2ab4ea7a56e19a1801fdf6240fe6754bd8e52"
    sha256 cellar: :any_skip_relocation, ventura:        "44f4ed94e42027362e5f888592dce4dc79c792f9a4a6a50d46147fdd8bd0f2d7"
    sha256 cellar: :any_skip_relocation, monterey:       "d2d77e38c76fb04658daa92af3764f901fb46fe1fe2b70110e27c4ebf216ff5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8bb1d7d1d48228280670c84afb3b243814a8ed7d5a696561f0ef68f3b23c738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ab8f8034afb8ebe0b4eaf0b434aaa4a844f91c60529ac8f6e0bf5ab041b968c"
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
