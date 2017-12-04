class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/v1.3.0.tar.gz"
  sha256 "e4d16bde2bb008f91181c0c98f1cfac06bce137d5c98604169fc8c0a8a810524"
  head "https://github.com/gradle/gradle-completion.git"

  bottle :unneeded

  depends_on "bash-completion" => :recommended

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
