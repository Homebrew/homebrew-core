class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.7.tar.gz"
  sha256 "9f44af2d1b1f3c5582620b7b5202ee2eb897a19bffc6e0d7ce95c6f0da2688bb"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c14c60bc5f047063f1f65d49b677a885ba1176503902c7619da7985354c9859"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c14c60bc5f047063f1f65d49b677a885ba1176503902c7619da7985354c9859"
    sha256 cellar: :any_skip_relocation, monterey:       "77563daca18aeb4823cccfe99a385b2e5e4619897e47e69a4699dd82de916287"
    sha256 cellar: :any_skip_relocation, big_sur:        "77563daca18aeb4823cccfe99a385b2e5e4619897e47e69a4699dd82de916287"
    sha256 cellar: :any_skip_relocation, catalina:       "77563daca18aeb4823cccfe99a385b2e5e4619897e47e69a4699dd82de916287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c14c60bc5f047063f1f65d49b677a885ba1176503902c7619da7985354c9859"
  end

  def install
    bin.install "gibo"
    bash_completion.install "shell-completions/gibo-completion.bash"
    zsh_completion.install "shell-completions/gibo-completion.zsh" => "_gibo"
    fish_completion.install "shell-completions/gibo.fish"
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"
  end
end
