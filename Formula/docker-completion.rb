class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://github.com/docker/docker"
  url "https://github.com/docker/docker/archive/v17.03.1-ce.tar.gz"
  version "17.03.1"
  sha256 "a8f1eefadf3966885ad0579facfc2017cca7dd3a0b20d086dfd798168716cb83"
  head "https://github.com/docker/docker"

  bottle :unneeded

  conflicts_with "docker",
    :because => "docker already includes these completion scripts"

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
