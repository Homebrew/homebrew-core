class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "5da1dcc3608db663fc1949042c6f3ec29184c9414c37c0e2bdfe9b19fd5d75c7"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f76a194f122166285bf9c474caab734c8fa97da7bc850bba2f355d6806bfdf1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87d341e368d2981ec53e89b01d6ba07f7892c53866235de412c5375fd2a43c47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aab3eeb2d1e5d6074c1beb9c18e0ef9bcb9f5a6b5a2aed14ccd765d94002c5d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1475ad56abbb4a653c2e659f4682ea88792661c736a180df66c7a59625cf79d"
    sha256 cellar: :any_skip_relocation, ventura:        "3211e9968caf7fdc3f505d158daf11d6de5bf4e94415cfba13325c0c45e3f9f2"
    sha256 cellar: :any_skip_relocation, monterey:       "f92559ea54bb3e19583342cccf0b3b95e8f62abfa381d598f85275e6ee5d522c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3d333695b9b8dca8d94428ac7bc4719cf3e2e9015e92fdbbc2aee2ec5496b4"
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
