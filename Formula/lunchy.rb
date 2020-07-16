class Lunchy < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/eddiezane/lunchy"
  url "https://github.com/eddiezane/lunchy.git",
      :tag      => "v0.10.4",
      :revision => "c78e554b60e408449937893b3054338411af273f"
  license "MIT"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "lunchy.gemspec"
    system "gem", "install", "lunchy-#{version}.gem"
    bin.install libexec/"bin/lunchy"
    bin.env_script_all_files(libexec/"bin", :GEM_HOME => ENV["GEM_HOME"])
    bash_completion.install "extras/lunchy-completion.bash"
    zsh_completion.install "extras/lunchy-completion.zsh" => "_lunchy"
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
    assert_equal <<~EOS, shell_output("#{bin}/lunchy uninstall com.example.echo")
      stopped com.example.echo
      uninstalled com.example.echo
    EOS

    assert_not_predicate plist, :exist?
  end
end
