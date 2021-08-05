class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.8",
      revision: "3967b7d28e15a020e4ee344283128ead633b3e0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1354d7231c8fa1cc3e9808060e82df0fd2c9039a54a492b36981fcdee28eb7c8"
  end

  conflicts_with "docker",
    because: "docker already includes these completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker"
    fish_completion.install "contrib/completion/fish/docker.fish"
    zsh_completion.install "contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
