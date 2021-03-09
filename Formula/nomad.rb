class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.0.4.tar.gz"
  sha256 "24f7d7853af6aa2c92645bddd0cbfa44797bc44d5375c4d53b52698d8c5968be"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62e0ec12e5fcb8f69d5d2512d5da01c2a717bad962fb6a3d046547bbf6823d06"
    sha256 cellar: :any_skip_relocation, big_sur:       "7cde444ca439554b1f223a19bc09147c71a4d6d1297e584d70bb582d0e80f24e"
    sha256 cellar: :any_skip_relocation, catalina:      "2083afc6560435aba845e0d3bbe933030968d6155a6f18becb9ecfa4dcfe30c5"
    sha256 cellar: :any_skip_relocation, mojave:        "b353d6c34e14f4ba048af85a116678f1b36a43bea30e3136ca3a32861324376a"
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
