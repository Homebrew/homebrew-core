class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/pueue-v0.11.0.tar.gz"
  sha256 "51461ee6c4ecfa834cd39d28afc73fc089c52e63030b8cad14145fab2c3a534a"
  license "MIT"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "7198c69473088117d81cbce3a2873852f8fb8b947298b128843116e1347f3dbc" => :big_sur
    sha256 "ba014e839a9178f7c2b90db5d7e96ae6495ba7127be184a5b09ae6101e457136" => :arm64_big_sur
    sha256 "1bac5127cd26fe85dfe204c523cf8618672110e35e4c42fc6fd06d7bbc542df3" => :catalina
    sha256 "52bf8fdd86821ac5864bda91b659980eff21869c70c8c0a6ede080318d70909f" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", libexec, "--path", "pueue"
    bin.install [libexec/"bin/pueue", libexec/"bin/pueued"]

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

    # bug report about the version in the release artifact
    # hopefully revert the change in next release
    # https://github.com/Nukesor/pueue/issues/169
    assert_match "Pueue daemon #{version.major_minor}", shell_output("#{bin}/pueued --version")
    assert_match "Pueue client #{version.major_minor}", shell_output("#{bin}/pueue --version")
  end
end
