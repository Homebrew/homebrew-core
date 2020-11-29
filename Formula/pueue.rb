class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.8.2.tar.gz"
  sha256 "8db2b7b27edb968889e2027dc6543225b07d37e61728e2bee1de441d5e5a9b7a"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "625bf7156f5b36a9da00ab5c6d7b82438bef441ecf316d2caceec26c470cef82" => :big_sur
    sha256 "505043b5ccd96cc18f2066042c5452c4405f8c149041ace5b58a9732c08c39ee" => :catalina
    sha256 "80d2d30bb0a7f39ebc16ebbbe6f1704ca3f7ac6414e790426df0e10f4a78a1a8" => :mojave
    sha256 "5d0d8030e1e02d717c9c2cfcf4c51d496b24841274a1f308e2688bdd9e37dfb2" => :high_sierra
  end

  depends_on "rust" => :build

  # remove in next release
  patch do
    url "https://github.com/Nukesor/pueue/commit/4a3c21953c0fe7553f4b0347d9012f997bd6b840.patch?full_index=1"
    sha256 "bd9cc57aef24c2c84681b020beff1c8560a8ac14910aa789db3cc669ba7fd842"
  end

  def install
    system "cargo", "install", *std_cargo_args

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"

    prefix.install_metafiles
  end

  plist_options manual: "pueued"

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
