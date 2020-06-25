class Pueue < Formula
  desc "Command-line tool for managing long-running shell commands"
  homepage "https://github.com/Nukesor/pueue"
  url "https://github.com/Nukesor/pueue/archive/v0.6.1.tar.gz"
  sha256 "fa9691ff7441bee19eab2bf15238a1c014059968dcc26cc394772061f1000122"
  head "https://github.com/Nukesor/pueue.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "801759298072f94496653cc498c1513ede1d0574d2d9bd81bcb46f331c257839" => :catalina
    sha256 "de5ecda424a1662b9c2b5fb9408e4979c447fedc0f9adf5aa5b9636e19c24f36" => :mojave
    sha256 "e0a63dc6a83558ce31105c7c74356b224437a00f1b7ba2759e72780a6d20477d" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

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
