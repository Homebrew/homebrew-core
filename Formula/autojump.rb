class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.1.tar.gz"
  sha256 "765fabda130eb4df70d1c1e5bc172e1d18f8ec22c6b89ff98f1674335292e99f"
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b2bc4e8a88f045cf59134eea71e64fd52c05fb5057dd48f9f8b00e84014f7975" => :sierra
    sha256 "c7f4586872c6ae5bff8c1f75cf575dc89dbb590b2164ba95ba073510a10bdd78" => :el_capitan
    sha256 "c7f4586872c6ae5bff8c1f75cf575dc89dbb590b2164ba95ba073510a10bdd78" => :yosemite
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
      [ -f #{etc}/profile.d/autojump.sh ] && . #{etc}/profile.d/autojump.sh

    If you use the Fish shell then add the following line to your ~/.config/fish/config.fish:
      [ -f #{HOMEBREW_PREFIX}/share/autojump/autojump.fish ]; and source #{HOMEBREW_PREFIX}/share/autojump/autojump.fish
    EOS
  end

  test do
    path = testpath/"foo/bar"
    path.mkpath
    output = %x(
      source #{etc}/profile.d/autojump.sh
      j -a "#{path.relative_path_from(testpath)}"
      j foo >/dev/null
      pwd
    ).strip
    assert_equal path.realpath.to_s, output
  end
end
