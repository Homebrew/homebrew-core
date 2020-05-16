class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.5.0.tar.gz"
  sha256 "84562b76cbf7d3bec7dce7337d15901ef5a5a750e749ca1aecb7bb6ff0385ce7"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56e541c2b6ac548053a0b72583856a57b10e621d017f342922989e569d07f37d" => :catalina
    sha256 "6e8360396e77f09834ca9cd25dfdcf477adb6b9c1af07db4ab409f21cfe2af28" => :mojave
    sha256 "08935e64534ca237fb4904fd17948d31647584b1e2855f1bd3f7aebfedbbcb2a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"

    prefix.install_metafiles
  end

  plist_options :manual => "pueued"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/pueued</string>
            <string>--verbose</string>
          </array>
          <key>KeepAlive</key>
          <false/>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/pueued.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/pueued.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir testpath/"Library/Preferences"

    begin
      pid = fork do
        exec bin/"pueued"
      end
      sleep 5
      cmd = "#{bin}/pueue status"
      assert_match /Task list is empty.*/m, shell_output(cmd)
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "Pueue daemon #{version}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version}", shell_output("#{bin}/pueue --version")
  end
end
