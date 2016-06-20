class Autojump < Formula
  desc "Shell extension to jump to frequently used directories"
  homepage "https://github.com/wting/autojump"
  url "https://github.com/wting/autojump/archive/release-v22.3.1.tar.gz"
  sha256 "e093d38bf247ba09a8a3bbc4f4f2710a23810022ce952d4461dacd4b74dfca93"

  head "https://github.com/wting/autojump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "164ca0b56523cca31454b37afb0938f6534ccd5362559f0e6e0a9ec015d89617" => :el_capitan
    sha256 "bac1fb7a05096b15b046bca2ec2615342f8480dc104bcca22a9ad51cc52dcef1" => :yosemite
    sha256 "c0ee5101a5b1f6be1f64a082b0d95c3d62ee3eca419aa06141bee6c6414b3646" => :mavericks
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
