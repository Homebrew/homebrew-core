class LunchyGo < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/sosedoff/lunchy-go"
  url "https://github.com/sosedoff/lunchy-go/archive/v0.2.1.tar.gz"
  sha256 "58f10dd7d823eff369a3181b7b244e41c09ad8fec2820c9976b822b3daee022e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6da299c289b38ba1a7ae8fdf081adedb1460b94d15016b0d641ffe898afac35" => :big_sur
    sha256 "3a3db921e9e82d0b87f24c5763980b6fec6e332fbb6ce4833b57e58aa8402f71" => :catalina
    sha256 "e372d1c35dbb73f11c6a826bd3bc5385f3376ebaa809972b8799a3c8483bcd09" => :mojave
    sha256 "7c2f3349ecf308bb53264577a1061714731126210996d17c2f7578c3bfc56056" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "lunchy", because: "both install a `lunchy` binary"

  def install
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

    assert_not_predicate plist, :exist?
  end
end
