class Antidote < Formula
  desc "Get the cure to slow zsh plugin management"
  homepage "https://getantidote.github.io/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "84048aa790b539d79008f690dd4694f97c479c1a2f3159ff0fff69a293528d76"
  license "MIT"

  uses_from_macos "zsh"

  def install
    pkgshare.install Dir["*"]
  end

  def caveats
    <<~EOS
      To use antidote, add the following to your ~/.zshrc:
        source #{HOMEBREW_PREFIX}/share/antidote/antidote.zsh

      You can edit the file yourself, or do that now by running:
        echo source #{HOMEBREW_PREFIX}/share/antidote/antidote.zsh >> \${ZDOTDIR:-~}/.zshrc
    EOS
  end

  test do
    (testpath/".zshrc").write "source #{HOMEBREW_PREFIX}/share/antidote/antidote.zsh\n"
    system "zsh", "--login", "-i", "-c", "antidote --help"
  end
end
