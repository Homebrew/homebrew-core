class Antigen < Formula
  desc "Plugin manager for zsh, inspired by oh-my-zsh and vundle"
  homepage "https://antigen.sharats.me/"
  url "https://github.com/zsh-users/antigen/releases/download/v2.2.3/v2.2.3.tar.gz"
  sha256 "bd3f1077050d52f459bc30fa3f025c44c528d625b4924a2f487fd2bacb89d61e"
  license "MIT"
  head "https://github.com/zsh-users/antigen.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7e25e7e84045a565f89b862af543154fa8564a4b2ca875fa894a641927b099f"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "bin/antigen.zsh"
  end

  def caveats
    <<~EOS
      To activate antigen, add the following to your ~/.zshrc:
        source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write "source #{HOMEBREW_PREFIX}/share/antigen/antigen.zsh\n"
    system "zsh", "--login", "-i", "-c", "antigen help"
  end
end
