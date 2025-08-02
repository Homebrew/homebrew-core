class FzfZshPlugin < Formula
  desc "ZSH plugin to enable fzf search for frequently used tools"
  homepage "https://github.com/unixorn/fzf-zsh-plugin"
  url "https://github.com/unixorn/fzf-zsh-plugin/archive/04ae801c5381a61889286345ee763347415d655c.tar.gz"
  version "2025.05.30"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
  license "Apache-2.0"
  head "https://github.com/unixorn/fzf-zsh-plugin.git", branch: "main"

  depends_on "fzf"
  uses_from_macos "zsh"

  def install
    pkgshare.install "fzf-zsh-plugin.plugin.zsh"
    pkgshare.install "fzf-settings.zsh"
    pkgshare.install "bin"
    pkgshare.install "completions"
  end

  def caveats
    <<~EOS
      To activate fzf-zsh-plugin, add the following to your .zshrc:
        source #{HOMEBREW_PREFIX}/share/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh
    EOS
  end

  test do
    assert_path_exists pkgshare/"fzf-zsh-plugin.plugin.zsh"
    assert_path_exists pkgshare/"bin"
    assert_path_exists pkgshare/"completions"
  end
end
