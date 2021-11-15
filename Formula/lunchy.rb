class Lunchy < Formula
  desc "Friendly wrapper for launchctl"
  homepage "https://github.com/eddiezane/lunchy"
  url "https://github.com/eddiezane/lunchy.git",
      tag:      "v0.10.4",
      revision: "c78e554b60e408449937893b3054338411af273f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dfda20ef97fcf03fcef1a84ead6e043337be20dcef25ca9ea6b55425cf915c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a82bfb8e963c2436508383b23c58857836e3125694b941e1fc0ed715b3939e7d"
    sha256 cellar: :any_skip_relocation, monterey:       "3c36357303f5d090c4e138bd82fd26aff95f44426c8ad4dd827f7472f243be87"
    sha256 cellar: :any_skip_relocation, big_sur:        "e82b712e4491089fd895dc09fa16de8df0f7eb1f522d33a7144c2574ca084782"
    sha256 cellar: :any_skip_relocation, catalina:       "ee66090fe1ddcb8204521e47ce805cc4e51708a0033d6916a36f4beba333b1e8"
    sha256 cellar: :any_skip_relocation, mojave:         "663eb72d186a577ab10af9ad50d2ac3748901206f329071e8e0aed432e73759f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "71f804d56f0ff8a37209dfc427400885833fffc2d6139cf40a99e91151099900"
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

    refute_predicate plist, :exist?
  end
end
