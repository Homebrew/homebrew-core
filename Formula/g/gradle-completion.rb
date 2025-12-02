class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v9.2.0.tar.gz"
  sha256 "982ec3aab5d7eb50b18af01fb50ca66556151928a374ed7234f21a34f0efe59c"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8743b79a4d925b8c373ce44893693258f9f9000ca10a9e908259b57c4df2e24"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
