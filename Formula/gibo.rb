class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/1.0.6.tar.gz"
  sha256 "b894beffb0f732cb4063e2c902f2620bab3b4a95fb58b4e40c90ec417fa49c88"

  bottle :unneeded

  def install
    bin.install "gibo"
    bash_completion.install "gibo-completion.bash"
    zsh_completion.install "gibo-completion.zsh" => "_gibo"
  end

  test do
    system "#{bin}/gibo", "-u"
    assert_includes shell_output("#{bin}/gibo Python"), "Python.gitignore"
  end
end
