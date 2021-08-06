class NodeExporter < Formula
  desc "Prometheus exporter for machine metrics"
  homepage "https://prometheus.io/"
  url "https://github.com/prometheus/node_exporter/archive/v1.2.1.tar.gz"
  sha256 "7c5a93722a6a1cd7de61b0d8d69951c56fe002bb7a90164f70738dbe7f78e10a"
  license "Apache-2.0"
  head "https://github.com/prometheus/node_exporter.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a2d0f58a7507651d8d9c130413af92470635acfca6513582e48c7c030c9775c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "661b7f371988c70cefe9cf852b4541e61581c558d2d0cc3eef09661d0f9211fb"
    sha256 cellar: :any_skip_relocation, catalina:      "0ea107911c1a5c5537ed4c4e9b762615380baff2be4bafcfdd9596ccaa911a22"
    sha256 cellar: :any_skip_relocation, mojave:        "9ab5a47bacb3f65b457030995ebd6579490931516fe3b8b86b5583e76d1cda67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acbcdf3ac39fb1596159f043cd6fe8dd6f5bb41e37f0bba3207d404dd1b5f85b"
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
