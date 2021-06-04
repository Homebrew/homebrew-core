class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/v1.4.1.tar.gz"
  sha256 "5d77f0c739fe983cfa86078a615f43be9be0e3ce05a3a7b70cb813a1ebd1ceef"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6889d645ade2d3296031a3bdebaec9c2622bf26755fae51024e1692f6872ccb3"
  end

  depends_on "bash-completion"

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle" => "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
