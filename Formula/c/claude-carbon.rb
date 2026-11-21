class ClaudeCarbon < Formula
  desc "Estimate the carbon footprint of Claude Code sessions"
  homepage "https://github.com/gwittebolle/claude-carbon"
  url "https://github.com/gwittebolle/claude-carbon/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "b1de0a1bc10b7d8d96d97035a4335a211fd7af8468e816bbae441fbc12b00300"
  license "MIT"
  head "https://github.com/gwittebolle/claude-carbon.git", branch: "main"

  uses_from_macos "jq", since: :sequoia
  uses_from_macos "sqlite"

  deny_network_access!

  def install
    libexec.install ".claude-plugin", "data", "hooks", "scripts", "skills", "templates", "types"
    (libexec/"INSTALL_METHOD").write "homebrew\n"
    bin.write_exec_script libexec/"scripts/claude-carbon"
  end

  def caveats
    <<~EOS
      To wire the status line and hooks into Claude Code, run:
        claude-carbon setup
      Before `brew uninstall claude-carbon`, run:
        claude-carbon uninstall
    EOS
  end

  test do
    system bin/"claude-carbon", "setup"
    settings = (testpath/".claude/settings.json").read
    assert_match "#{opt_libexec}/scripts/statusline.sh", settings
    refute_match "Cellar", settings
    assert_path_exists testpath/".claude/claude-carbon/carbon.db"

    session = '{"session_id":"brew","model":{"id":"claude-opus-5"},"cost":{"total_cost_usd":0.5}}'
    assert_match "gCO₂", pipe_output("#{opt_libexec}/scripts/statusline.sh --segment", session)

    system bin/"claude-carbon", "uninstall"
    refute_match "statusline.sh", (testpath/".claude/settings.json").read
  end
end
