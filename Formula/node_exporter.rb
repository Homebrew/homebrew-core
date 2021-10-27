class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.2.2.tar.gz"
  sha256 "3b7b710dad97d9d2b4cb8c3f166ee1c86f629cce59062b09d4fb22459163ec86"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24542f9ea4c259bcc715a11a2be45cf63102ae3a1e51a7f9d1df1774229427c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08defe8d74459977bc0bf5b5da1e0c09bada5943fd6bbb78d053deb0f6ad1505"
    sha256 cellar: :any_skip_relocation, monterey:       "4534d77e58bb1d29981f68562225aa48dcb7aaffd907276ccbb2e99faf8a2d17"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbac191f8d01fe6a3cd41a389d02ac800e6b823ddb0a5bb9fc60f4d7e59da41c"
    sha256 cellar: :any_skip_relocation, catalina:       "71aa1e6052258257c504b3968027c43238e62ab583efaf1937670ba25defce19"
    sha256 cellar: :any_skip_relocation, mojave:         "d79d282260ddd651b834688c74b5255d74ccd0c67d9c504efe71882503ebd6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5937f64800a35b0205c36e679d7d7f83042092e8e9cb5ef71fb145b22e4e296c"
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
