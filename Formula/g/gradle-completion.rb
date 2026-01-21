class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v9.3.0.tar.gz"
  sha256 "07e6fc54a215abcd9c1a9a28e45607c666f20d72d6d68aac69a90e66c59f55e5"
  license "MIT"
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad63a3d111e4a2739ff04840f64149ade8baa408d1b13db7ed9e6b39158f038e"
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
