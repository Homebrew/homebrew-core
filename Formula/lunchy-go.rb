class LunchyGo < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/sosedoff/lunchy-go"
  url "https://github.com/sosedoff/lunchy-go/archive/v0.2.1.tar.gz"
  sha256 "58f10dd7d823eff369a3181b7b244e41c09ad8fec2820c9976b822b3daee022e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dadf4a849956c4f09eba6b8c18aed458686138e91254675004e7d15caf4a2a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08ba310aca8771aeeafc4b83bba77cfb57a5bb776752528035e21177c079e03"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcf57a3daf16341b4ef6e321cf64f1be1e65242b7f2b32f534fa358b2a83f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6da299c289b38ba1a7ae8fdf081adedb1460b94d15016b0d641ffe898afac35"
    sha256 cellar: :any_skip_relocation, catalina:       "3a3db921e9e82d0b87f24c5763980b6fec6e332fbb6ce4833b57e58aa8402f71"
    sha256 cellar: :any_skip_relocation, mojave:         "e372d1c35dbb73f11c6a826bd3bc5385f3376ebaa809972b8799a3c8483bcd09"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7c2f3349ecf308bb53264577a1061714731126210996d17c2f7578c3bfc56056"
  end

  depends_on "go" => :build
  depends_on :macos

  conflicts_with "lunchy", because: "both install a `lunchy` binary"

  def install
    ENV["GO111MODULE"] = "auto"
    system "go", "build", *std_go_args
    bin.install bin/"lunchy-go" => "lunchy"
  end

  test do
    plist = testpath/"Library/LaunchAgents/com.example.echo.plist"
    plist.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>com.example.echo</string>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/cat</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
      </plist>
    EOS

    assert_equal "com.example.echo\n", shell_output("#{bin}/lunchy list echo")

    system "launchctl", "load", plist
    assert_equal <<~EOS, shell_output("#{bin}/lunchy remove com.example.echo")
      removed #{plist}
    EOS

    refute_predicate plist, :exist?
  end
end
