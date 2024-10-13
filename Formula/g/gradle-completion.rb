class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "5d77f0c739fe983cfa86078a615f43be9be0e3ce05a3a7b70cb813a1ebd1ceef"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3502e3b4c77d039e49bc7d8879f4b77af117162a5ee9e7aec3a1175ac61187de"
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
