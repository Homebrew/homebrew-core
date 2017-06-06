class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.11.3.tar.gz"
  sha256 "2d34103a7f9645059270763a0cfe82085f6d9fe61b2a85aca558689df0e7b006"

  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cfa51b1d88968e16025ee7174de1ec2de35c1e592d5f4e5fcdbff48ba91d755" => :sierra
    sha256 "96729b6eb0019f815de28dc69909a314b128a1530e0bff648b388db8fe710175" => :el_capitan
    sha256 "7f14742018f1604c5723ac92fe578166872ebc23928db4a5df05eb15c8a5f8c7" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  def caveats; <<-EOS.undent
    For direnv to work properly it needs to be hooked into the shell.
    Each shell has its own extension mechanism:

    Bash
      Add the following line at the end of the "~/.bashrc" file:
        eval "$(direnv hook bash)"
      Make sure it appears even after rvm, git-prompt and other shell extensions
      that manipulate the prompt.

    Zsh
      Add the following line at the end of the "~/.zshrc" file:
        eval "$(direnv hook zsh)"

    Fish
      Add the following line at the end of the "~/.config/fish/config.fish" file:
        eval (direnv hook fish)

    Tcsh
      Add the following line at the end of the "~/.cshrc" file:
        eval `direnv hook tcsh`
    EOS
  end

  test do
    system bin/"direnv", "status"
  end
end
