class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.2.2.tar.gz"
  sha256 "3b7b710dad97d9d2b4cb8c3f166ee1c86f629cce59062b09d4fb22459163ec86"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb54142bf7bbec82fa2e61401aea8f2d52bc0daa072f799dea944b4ef76ef456"
    sha256 cellar: :any_skip_relocation, big_sur:       "51e8055b0532fed44e76081c3af03666e11cd09cfbda040e8883e6b46b7556d8"
    sha256 cellar: :any_skip_relocation, catalina:      "22d0556f9cac4d74560d035c77bc83a8c1a3c537c6d13dfa31005a865fc8d31a"
    sha256 cellar: :any_skip_relocation, mojave:        "17b789627b808c2a7d0db53276f6daae97fb674dcd6e2b5be8c845866fa865b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64610c8b27e3cd02539871d559dcff67ed413f81c7b67d4417843f3f60ad8eb2"
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

  plist_options manual: "node_exporter"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/node_exporter_brew_services</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <false/>
          <key>StandardErrorPath</key>
          <string>#{var}/log/node_exporter.err.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/node_exporter.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match "node_exporter", shell_output("#{bin}/node_exporter --version 2>&1")

    fork { exec bin/"node_exporter" }
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
