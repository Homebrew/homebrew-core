class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "57b5c0d15a37d497f95a8ba08988c4fd8a7145644b94840e91dc54b61a756cad"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "782b635ccecd12edf61dfe494259b2cee9f11d7652614b874976b62cd181899e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38f56905ffa765684abe7f4bfe8069c4818cb11f68aecd17942215260a2c1f98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ba81861d169182af270e6af877a7b26904af259404da63dd02cb1ee1b79a3b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d0e85d58752be73e347eafc77ddaf377b19b5d0d9e44189678bbb7ae3b6f08d"
    sha256 cellar: :any_skip_relocation, ventura:        "71215ba019c623c5e826b6a98c444c3ce34175de04e15485f27cb5fbb5a8201e"
    sha256 cellar: :any_skip_relocation, monterey:       "51c75be7a2d1010470af40b7e4a97dab6ce5eccc7f8f89980651614f10c17c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "834a2f113e0a8b6e3aed4778f82efe6781df8790e739b7258c99e485efdc67a2"
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
