class GradleCompletion < Formula
  desc "Bash and Zsh completion for Gradle"
  homepage "https://gradle.org/"
  url "https://github.com/gradle/gradle-completion/archive/refs/tags/v9.8.0.tar.gz"
  sha256 "15672384608402919caf0d7c51e3b6675c006724b099045d21a269e8cb0b006d"
  license "MIT"
  compatibility_version 1
  head "https://github.com/gradle/gradle-completion.git", branch: "master"

  bottle do
    manifest_sha256 "9e7520a7b0dadb1b49e76ac386f5984b2407849ec9a6900d745bb3889ecd0109"
    sha256 cellar: :any_skip_relocation, all: "0d36610aa4c9370f5d9d2450cc2ed410873cf739bc5c7593b50d608a26dccf5d"
  end

  def install
    bash_completion.install "gradle-completion.bash" => "gradle"
    zsh_completion.install "_gradle"
  end

  test do
    assert_match "-F _gradle",
      shell_output("bash -c 'source #{bash_completion}/gradle && complete -p gradle'")
  end
end
