class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.7.tar.gz"
  sha256 "9f44af2d1b1f3c5582620b7b5202ee2eb897a19bffc6e0d7ce95c6f0da2688bb"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49494492756fd72667dbd899a0406b32f89cc044b93a4d31cb03cfafafbdb3b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49494492756fd72667dbd899a0406b32f89cc044b93a4d31cb03cfafafbdb3b4"
    sha256 cellar: :any_skip_relocation, monterey:       "473b0891bf471637cb3d0bd53e44cefd3e32abe1d596579a9cf243ed3f589288"
    sha256 cellar: :any_skip_relocation, big_sur:        "473b0891bf471637cb3d0bd53e44cefd3e32abe1d596579a9cf243ed3f589288"
    sha256 cellar: :any_skip_relocation, catalina:       "473b0891bf471637cb3d0bd53e44cefd3e32abe1d596579a9cf243ed3f589288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49494492756fd72667dbd899a0406b32f89cc044b93a4d31cb03cfafafbdb3b4"
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
