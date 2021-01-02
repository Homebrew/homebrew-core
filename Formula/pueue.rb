class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.10.2.tar.gz"
  sha256 "dbd333079df9249609f6a01d7c96175ec9d74f9d621688b95ec755134b7fa1f5"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed66a74389624105d7ddb7ce0b7f536744cf0bd0e39b26a2b3ea8e1918f6f4c3" => :big_sur
    sha256 "17654df18d91053bc9ca461b1cb1e037087f38d3eb5083226a9f5fd016f6e829" => :arm64_big_sur
    sha256 "167f42160fb8386a8db8b672c132db6262f25f21a29c01c1887c6d0453b9f2b7" => :catalina
    sha256 "95aa01fda1fbbf87eacbf00fd71e9668378d5afed3198b2755c692b9155207db" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system "./build_completions.sh"
    bash_completion.install "utils/completions/pueue.bash" => "pueue"
    fish_completion.install "utils/completions/pueue.fish" => "pueue.fish"
    zsh_completion.install "utils/completions/_pueue" => "_pueue"

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
