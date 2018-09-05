class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.5.1.tar.gz"
  sha256 "765fabda130eb4df70d1c1e5bc172e1d18f8ec22c6b89ff98f1674335292e99f"
  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80aef4fa4699bad12cae0c1a6d6db2632d15c13b503796db5c9889f7b43a3279" => :mojave
    sha256 "8e302e0a90b898349749c4b83b3c758f4af76ad415f6ac5e245cc0df9c2c90e6" => :high_sierra
    sha256 "29d37b9fc31a978d0767c4925e88fa9fe3cebf4a9f9278fa82a96baf5caa0db4" => :sierra
    sha256 "29d37b9fc31a978d0767c4925e88fa9fe3cebf4a9f9278fa82a96baf5caa0db4" => :el_capitan
    sha256 "29d37b9fc31a978d0767c4925e88fa9fe3cebf4a9f9278fa82a96baf5caa0db4" => :yosemite
  end

  def install
    system "./install.py", "-d", prefix, "-z", zsh_completion

    # Backwards compatibility for users that have the old path in .bash_profile
    # or .zshrc
    (prefix/"etc").install_symlink prefix/"etc/profile.d/autojump.sh"

    libexec.install bin
    bin.write_exec_script libexec/"bin/autojump"
  end

  def caveats; <<~EOS
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
    output = `
      source #{etc}/profile.d/autojump.sh
      j -a "#{path.relative_path_from(testpath)}"
      j foo >/dev/null
      pwd
    `.strip
    assert_equal path.realpath.to_s, output
  end
end
