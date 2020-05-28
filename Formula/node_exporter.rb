class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.0.0.tar.gz"
  sha256 "2d82dac251e789b75879ebf1ebe94d1dc15c59ffa28ffe4e15b8d2ff63190607"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "fffc1654bce9eb90d4c9e22ad028a2d1ee5537611ed50302f71020613802c838" => :catalina
    sha256 "5e77f96bb6056febf980328256e9f19417a1fb1b98ab2c23acf27428e28decc3" => :mojave
    sha256 "757687a8705c921ea02ea53714f4707bf5b09c479e96a1ca33756241d9c9b848" => :high_sierra
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

  plist_options :manual => "node_exporter"

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
    assert_match /node_exporter/, shell_output("#{bin}/node_exporter --version 2>&1")

    fork { exec bin/"node_exporter" }
    sleep 2
    assert_match "# HELP", shell_output("curl -s localhost:9100/metrics")
  end
end
