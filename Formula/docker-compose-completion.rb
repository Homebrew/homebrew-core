class DockerComposeCompletion < Formula
  desc "Docker-compose completion script"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.24.1.tar.gz"
  sha256 "63a0e0d3819ff77aebd3d5ea30f77b36475ed522c4dabed2eb10636e35aa9370"
  head "https://github.com/docker/compose.git"

  bottle :unneeded

  conflicts_with "docker-compose",
    :because => "docker-compose already includes completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker-compose"
    fish_completion.install "contrib/completion/fish/docker-compose.fish"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    assert_match "-F _docker_compose",
      shell_output("bash -c 'source #{bash_completion}/docker-compose && complete -p docker-compose'")
  end
end
