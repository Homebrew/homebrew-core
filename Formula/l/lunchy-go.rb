class LunchyGo < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/sosedoff/lunchy-go"
  url "https://github.com/sosedoff/lunchy-go/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "58f10dd7d823eff369a3181b7b244e41c09ad8fec2820c9976b822b3daee022e"
  license "MIT"
  head "https://github.com/sosedoff/lunchy-go.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9073ddcd234f04940378a64e36b1657daf2f1519ad98e61691c7066b2fb881ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "fba65395dd87db751184f0d6a5023465484f321d47b4cd62ff0095837656c1e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce24f8e0a143748b271ad64e33834336cc504c8e14f8dd61ebaac7b06f4eafd5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf0dbfac8d527789d752334946988aba0d6bc4a1858e1d94963a8214ee291041"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dadf4a849956c4f09eba6b8c18aed458686138e91254675004e7d15caf4a2a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08ba310aca8771aeeafc4b83bba77cfb57a5bb776752528035e21177c079e03"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ba8cd414b18ac0bb9855f2df7b3a910e6bf312176cc6eec0ca099c134593e61"
    sha256 cellar: :any_skip_relocation, ventura:        "0eee3b43e4891dadceba85ae87c572308196b55082423a97046b81814a67c2c2"
    sha256 cellar: :any_skip_relocation, monterey:       "1dcf57a3daf16341b4ef6e321cf64f1be1e65242b7f2b32f534fa358b2a83f03"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6da299c289b38ba1a7ae8fdf081adedb1460b94d15016b0d641ffe898afac35"
    sha256 cellar: :any_skip_relocation, catalina:       "3a3db921e9e82d0b87f24c5763980b6fec6e332fbb6ce4833b57e58aa8402f71"
  end

  depends_on "go" => :build
  depends_on :macos

  conflicts_with "lunchy", because: "both install a `lunchy` binary"

  # Add go.mod
  patch do
    url "https://github.com/sosedoff/lunchy-go/commit/756ad7892ca91763c9c1e70ff9c6570607843725.patch?full_index=1"
    sha256 "e929312d6bb2441343e488988981e27fedab365fd963020089553608a9f93d5b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"lunchy")
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

    refute_path_exists plist
  end
end
