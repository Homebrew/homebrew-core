class ComposerCompletion < Formula
  desc "Bash completion for composer and context sensitive hints"
  homepage "https://github.com/webdevel/composer-bash-completion"
  url "https://github.com/webdevel/composer-bash-completion/archive/1.0.0.tar.gz"
  sha256 "dcf39d5e6577d25e251a1194d9a12f4482365e79a75664fe1846e3218f5363cb"
  head "https://github.com/webdevel/composer-bash-completion.git"
  bottle :unneeded
  depends_on "bash-completion@2"
  depends_on "composer"

  def install
    bash_completion.install "composer-completion.bash" => "composer"
  end

  test do
    assert_match "complete -F _composer composer",
      shell_output("source #{bash_completion}/composer && complete -p composer")
  end
end
