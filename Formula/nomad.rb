class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.3.tar.gz"
  sha256 "18eb2b7fcd4d32952546b3d8b052e755dedc4c63e36527404db6abdce01b197d"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "424df70a9e612b47fba9b72761ce032f5c9a96ca80f14978ba0703cf8c652130"
    sha256 cellar: :any_skip_relocation, big_sur:       "93ea67be1eea3da7e0c0f5e2e13e9791e87a1dbdb66e8a1517ca27532fce5df7"
    sha256 cellar: :any_skip_relocation, catalina:      "5a07c7a9eda30d79b35bac0bba71fd073598dd1dc9fb16c3e61ef453a9d50148"
    sha256 cellar: :any_skip_relocation, mojave:        "4ba52bf3457e756b1d5a82961ad94f43ddedbce33685fce67a0731535c486ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9a4e1206128677c5a20f3245d2d6668e0e1766778f1ea72aace09555e19312e"
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
