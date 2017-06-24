class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/v1.2.0.tar.gz"
  sha256 "47c23526d94ac4fa5862ed9d6e3cd4b4704ecb1f880f60827f0d154a7b75392e"
  head "https://github.com/gradle/gradle-completion.git"

  bottle :unneeded

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
