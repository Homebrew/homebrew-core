class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.8.tar.gz"
  sha256 "07bcc8e7fb4941e095c3740fc4497f0f318cb72c3b0ae83aa13635cefe60ade6"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, catalina:       "fd7791136b3bc08945b017def9fcecee3904250e0870ccd20c8a28b68160198e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010d9cc6f4ec371787d333657483eeb7980b640041688a60514db8376e44eaa8"
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
