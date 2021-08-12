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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10c3e725f35828e54645d90f4e8865068de1122cd0f55b2fbde812e871c2e45d"
    sha256 cellar: :any_skip_relocation, big_sur:       "f1c1467f8db86b9578363d2e0705b2b150ac5843a7a780d82db57c4bab305574"
    sha256 cellar: :any_skip_relocation, catalina:      "69c66da1f5837d53c694ec8210807fdec373fbcda411ef9e567339713a9c6431"
    sha256 cellar: :any_skip_relocation, mojave:        "df2e4a99a7060703980b73f23ae1d7628a74d5f6ce098577dc0877ce5ec7fd23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ae95a4372832bd1bd2f76ffadf74ba51db0437c6731e5cc29719b7eb0c83806"
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
