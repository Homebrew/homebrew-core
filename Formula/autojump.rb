class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.3.4.tar.gz"
  sha256 "3fbd83f19e60514887c7efa1ce1b9015179c55c381a8867417eed933f2657984"

  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c54876bea6f113a56470ca1313fd5fb89d316b6913b175d17ed46cc39f0226c" => :el_capitan
    sha256 "6160d25c96b4cae7a2764a4235696c18696829b54f1ca34e5e5f99de79b7ff23" => :yosemite
    sha256 "5af726c31ecfea4c1b08ade48c931e1ff0834e5cb208ce93213aa8b2bde13c59" => :mavericks
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
