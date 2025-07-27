class FzfZshPlugin < Formula
  desc "ZSH plugin to enable fzf search for frequently used tools"
  homepage "https://github.com/unixorn/fzf-zsh-plugin"
  url "https://github.com/unixorn/fzf-zsh-plugin/archive/04ae801.tar.gz"
  version "2025.05.30"
  sha256 "0253112c9a18d3c3ac9473b68a4f96be86a65503781f45be218f430068ab8211"
  license "Apache-2.0"
  head "https://github.com/unixorn/fzf-zsh-plugin.git", branch: "main"

  depends_on "fzf"
  uses_from_macos "zsh" => :run

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
    assert_predicate pkgshare/"fzf-zsh-plugin.plugin.zsh", :exist?
    assert_predicate pkgshare/"bin", :exist?
    assert_predicate pkgshare/"completions", :exist?
  end
end
