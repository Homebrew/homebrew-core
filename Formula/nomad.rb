class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v0.12.9.tar.gz"
  sha256 "22616dcb3e254a14a367bce1090edbebcd1155424b9b5097816f6584f1260e7d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "517ba4b2e17bcbc0d4a2c45bc70ef42a50b4ac67e33ca20c41bcdaca38e1625c" => :big_sur
    sha256 "883a73f26ca8e1c80d0ef5266a443ca43774fb6355d4da417834b5e9be10bad1" => :catalina
    sha256 "c76e3b12b64e897018b2348a37799860c33e028a5355ac68685ba9f1f1665ed3" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-tags", "ui"
  end

  plist_options manual: "nomad agent -dev"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/nomad</string>
            <string>agent</string>
            <string>-dev</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/nomad.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/nomad.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nomad", "agent", "-dev"
    end
    sleep 10
    ENV.append "NOMAD_ADDR", "http://127.0.0.1:4646"
    system "#{bin}/nomad", "node-status"
  ensure
    Process.kill("TERM", pid)
  end
end
