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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d6c9246bb9cb10b13f36f5b297bba560b5339094ed65da16e57274ca9302bd87"
    sha256 cellar: :any_skip_relocation, big_sur:       "3831bbd1df02820cf90bd2f99877a7798f8f92863c19acc864175375bfe3a144"
    sha256 cellar: :any_skip_relocation, catalina:      "ac251c800cb74648fefc59fdd99570afdf51e26e57dc320aefbfb0e06971f5df"
    sha256 cellar: :any_skip_relocation, mojave:        "ad7552780d162217a5c55daccaafc1992fa3d183eb2a821df737673604503ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bef4277e814809b4c2af4325af9849b2466b6c63aa0dc3fef25840247ba8f9bf"
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
