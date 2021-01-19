class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.3.tar.gz"
  sha256 "00daf3698e17ac3ac788d529877c03ee80c3790472a85d0ed063ac3a354c37b1"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b3d6ec6dd27c3b162d0e4af4351cff318704f24641a20e1fbde2ceef170bcb1" => :big_sur
    sha256 "3cfea6d7660fb84079ca96c145b09f81236a765bb9a63e63680f3c9cdca73f2b" => :arm64_big_sur
    sha256 "86f9b762fdc71023781e999f2269c1c9af87ad7c22f01b6ad9481e6583cf972a" => :catalina
    sha256 "aeabdd63a425d4505d8b5f9aa6f3895e3447e8835d2ba82799e6de46162dc0f4" => :mojave
    sha256 "225ebe9420dc834c2381b9c0fdadd1acb19a9152db6822ebce1ee8071db9bdd3" => :high_sierra
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
    output = `
      source #{etc}/profile.d/autojump.sh
      j -a "#{path.relative_path_from(testpath)}"
      j foo >/dev/null
      pwd
    `.strip
    assert_equal path.realpath.to_s, output
  end
end
