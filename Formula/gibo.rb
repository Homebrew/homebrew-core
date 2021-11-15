class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.4.tar.gz"
  sha256 "35debd3e345caf8eeb4441a3877b7e33c98caec5f5c5e2e61da1cb1a263aec4b"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af671cfa2e8503e978d8623829d236932fb1bc9e5e4df3ef709d5ecb8c9f91c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "af671cfa2e8503e978d8623829d236932fb1bc9e5e4df3ef709d5ecb8c9f91c1"
    sha256 cellar: :any_skip_relocation, monterey:       "106c82cc27f9897f960c131a543cd93c4ca449c4004aebfc7f07cc46f0059157"
    sha256 cellar: :any_skip_relocation, big_sur:        "106c82cc27f9897f960c131a543cd93c4ca449c4004aebfc7f07cc46f0059157"
    sha256 cellar: :any_skip_relocation, catalina:       "106c82cc27f9897f960c131a543cd93c4ca449c4004aebfc7f07cc46f0059157"
    sha256 cellar: :any_skip_relocation, mojave:         "106c82cc27f9897f960c131a543cd93c4ca449c4004aebfc7f07cc46f0059157"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af671cfa2e8503e978d8623829d236932fb1bc9e5e4df3ef709d5ecb8c9f91c1"
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
