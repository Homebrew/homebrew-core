class Nomad < Formula
  desc "Distributed, Highly Available, Datacenter-Aware Scheduler"
  homepage "https://www.nomadproject.io"
  url "https://github.com/hashicorp/nomad/archive/v1.1.0.tar.gz"
  sha256 "cb9bb49a266b1720e78e6899e48e9dbfadd927d6a356e378980e4e398cfb4c78"
  license "MPL-2.0"
  head "https://github.com/hashicorp/nomad.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7222d152d853db2c66db323c43c79268e598da91b4b8d9ce2889df5c7d73ac9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7d4c0f85b2e451f535b9e4b2be824016a5b3e97ce8999e763d9c2faee061c56"
    sha256 cellar: :any_skip_relocation, catalina:      "fdfb1f0757a5780be2ee07e6fc189e975f90c8bd90fd2dd7c1e8cd44aa0e2c34"
    sha256 cellar: :any_skip_relocation, mojave:        "4f1cfdd22d2f46abc29550c6c382bb741817de85a78a9dcc943541b884de1842"
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
