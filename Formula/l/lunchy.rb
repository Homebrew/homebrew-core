class Lunchy < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/eddiezane/lunchy"
  url "https://github.com/eddiezane/lunchy.git",
      tag:      "v0.10.4",
      revision: "c78e554b60e408449937893b3054338411af273f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c17a734e1506ea38877dc23b77d843b7975ab2502a459716c1252eb5569d2a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c17a734e1506ea38877dc23b77d843b7975ab2502a459716c1252eb5569d2a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c17a734e1506ea38877dc23b77d843b7975ab2502a459716c1252eb5569d2a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "185916bb389986bfc7c1e52fab8cd544590dd16860271c12a0665131c4d27314"
    sha256 cellar: :any_skip_relocation, ventura:       "185916bb389986bfc7c1e52fab8cd544590dd16860271c12a0665131c4d27314"
  end

  depends_on :macos

  uses_from_macos "ruby"

  conflicts_with "lunchy-go", because: "both install a `lunchy` binary"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lunchy.gemspec"
    system "gem", "install", "lunchy-#{version}.gem"
    bin.install libexec/"bin/lunchy"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bash_completion.install "extras/lunchy-completion.bash" => "lunchy"
    zsh_completion.install "extras/lunchy-completion.zsh" => "_lunchy"
  end

  test do
    plist = testpath/"Library/LaunchAgents/com.example.echo.plist"
    plist.write <<~XML
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
    XML

    assert_equal "com.example.echo\n", shell_output("#{bin}/lunchy list echo")

    system "launchctl", "load", plist
    assert_equal <<~EOS, shell_output("#{bin}/lunchy uninstall com.example.echo")
      stopped com.example.echo
      uninstalled com.example.echo
    EOS

    refute_path_exists plist
  end
end
