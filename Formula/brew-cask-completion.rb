class BrewCaskCompletion < Formula
  desc "Bash & Fish completion for brew-cask"
  homepage "https://github.com/xyb/homebrew-cask-completion"
  url "https://github.com/xyb/homebrew-cask-completion/archive/v2.1.tar.gz"
  sha256 "27c7ea3b7f7c060f5b5676a419220c4ce6ebf384237e859a61c346f61c8f7a1b"
  head "https://github.com/xyb/homebrew-cask-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "homebrew-cask-completion.bash" => "brew-cask"
    fish_completion.install "brew-cask.fish"
  end

  test do
    assert_match "-F _brew_cask",
      shell_output("source #{bash_completion}/brew-cask && complete -p brew-cask")
  end
end
