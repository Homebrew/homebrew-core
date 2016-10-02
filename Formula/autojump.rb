class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.0.tar.gz"
  sha256 "8da11ff82dabfc9d0ea10f453ed90d601fbf1a212f9e8ad42965a87986045101"
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "274b5bb680afeb031e1abfabc7d79060f4779e85014f715708f9e273ebab0813" => :sierra
    sha256 "274b5bb680afeb031e1abfabc7d79060f4779e85014f715708f9e273ebab0813" => :el_capitan
    sha256 "274b5bb680afeb031e1abfabc7d79060f4779e85014f715708f9e273ebab0813" => :yosemite
  end

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats; <<-EOS.undent
    Add the following line to your ~/.bash_profile or ~/.zshrc file (and remember
    to source the file to update your current session):
      [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh

    If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
      [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish
    EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    output = %x(
      source #{HOMEBREW_PREFIX}/etc/profile.d/autojump.sh
      j -a "#{path.relative_path_from(testpath)}"
      j foo >/dev/null
      pwd
    ).strip
    assert_equal path.realpath.to_s, output
  end
end
