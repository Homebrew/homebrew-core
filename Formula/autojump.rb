class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.3.tar.gz"
  sha256 "00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/wting/autojump.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c57ada4da08511d187b59d225b870c3ebee4c04aeeed9a066980e69a2f1a773"
    sha256 cellar: :any_skip_relocation, big_sur:       "6a803054ba48635b80cf303c9de79c4b448a6b293168a733c521f3d0b5046dff"
    sha256 cellar: :any_skip_relocation, catalina:      "6a803054ba48635b80cf303c9de79c4b448a6b293168a733c521f3d0b5046dff"
    sha256 cellar: :any_skip_relocation, mojave:        "6a803054ba48635b80cf303c9de79c4b448a6b293168a733c521f3d0b5046dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "155704b3dbb470bf4b4e21e713e808a6c4aa0428447cd1869c6cc75c56bf0517"
  end

  depends_on "python@3.9"

  def install
    system Formula["python@3.9"].opt_bin/"python3", "install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    (bin/"autojump").write_env_script libexec/"bin/autojump", PATH: "#{Formula["python@3.9"].libexec}/bin:$PATH"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile or ~/.zshrc file:
        [ -f #{etc}/profile.d/autojump.sh ] && . #{etc}/profile.d/autojump.sh

      If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
        [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish

      Restart your terminal for the settings to take effect.
    EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    cmds = [
      ". #{etc}/profile.d/autojump.sh",
      "j -a \"#{path.relative_path_from(testpath)}\"",
      "j foo >/dev/null",
      "pwd",
    ]
    assert_equal path.realpath.to_s, shell_output("bash -c '#{cmds.join("; ")}'").strip
  end
end
