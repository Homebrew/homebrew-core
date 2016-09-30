class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.4.1.tar.gz"
  sha256 "4756132c992e3da82bb3e2b3cbc449168f85355f63e1d3fb6c1f43d36d1690c6"
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fe815d90822007242fd254529774660c5c85becdfff5353f1935f9d2e30b0dd3" => :sierra
    sha256 "3094fb0c2ad201dfe6718568dff87ad141bcfade1bb7e088d66101f94f252dd3" => :el_capitan
    sha256 "fe815d90822007242fd254529774660c5c85becdfff5353f1935f9d2e30b0dd3" => :yosemite
    sha256 "fe815d90822007242fd254529774660c5c85becdfff5353f1935f9d2e30b0dd3" => :mavericks
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
