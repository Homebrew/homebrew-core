class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/v1.3.1.tar.gz"
  sha256 "d2a83ed883f5ca7f209e23f3b0b500bd849221f8a5aeaab1517afade8f20b3d2"
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
