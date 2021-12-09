class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/2.2.5.tar.gz"
  sha256 "f0c84cae0cb55d12ff063ee33fb61246f246224999229a082c18376cb62957e4"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2eb6cdf80716ffe27ff74f8feb53bb17e557b15124f286c7bf0282a302cec3d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2eb6cdf80716ffe27ff74f8feb53bb17e557b15124f286c7bf0282a302cec3d"
    sha256 cellar: :any_skip_relocation, monterey:       "3b5c82bda1b0dd1e7d1cfc69aa6205d41ab4cbce64a4e919e73f066868435d40"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5c82bda1b0dd1e7d1cfc69aa6205d41ab4cbce64a4e919e73f066868435d40"
    sha256 cellar: :any_skip_relocation, catalina:       "3b5c82bda1b0dd1e7d1cfc69aa6205d41ab4cbce64a4e919e73f066868435d40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2eb6cdf80716ffe27ff74f8feb53bb17e557b15124f286c7bf0282a302cec3d"
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
