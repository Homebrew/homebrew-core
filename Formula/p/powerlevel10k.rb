class Powerlevel10k < Formula
  desc "Theme for zsh"
  homepage "https://github.com/romkatv/powerlevel10k"
  url "https://github.com/romkatv/powerlevel10k/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "ac3395e572b5d5b77813009fd206762268fc73b9d305c2a99f4f26ad6fecf024"
  license "MIT"
  head "https://github.com/romkatv/powerlevel10k.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d18aa0edf6740bb6d86a30a62ac74b56da45dc75dad4b46981a4eff7d0f9bc73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "095088b4efba21b9e37c2eb532cc5e6744b3d2138cf83707f54d456e78950ac0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3242dd77782bb643a0fe198e1fc253669914041e9d41446e292a0a7ac3b6e92"
    sha256 cellar: :any_skip_relocation, ventura:        "b33d65ad5a8317162c078412494997179650a6e758ccf72ee2c1be5d1fae78df"
    sha256 cellar: :any_skip_relocation, monterey:       "41fd63880caa4e827972b094030772e91ab943945b2dc2555f1fd861e42a4c2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcd2b21e16c87f97b6689c7fe25214955ecb1adbd13fbb83d39352bebe276fa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ffa9d63360e6be1874b0e2b401cb72750df6aa903da20125852405d91b5d5b0"
  end

  uses_from_macos "zsh" => :test

  def install
    system "make", "pkg"
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate this theme, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme

      You will also need to restart your terminal for this change to take effect.
    EOS
  end

  test do
    output = shell_output("zsh -fic '. #{pkgshare}/powerlevel10k.zsh-theme && (( ${+P9K_SSH} )) && echo SUCCESS'")
    assert_match "SUCCESS", output
  end
end
