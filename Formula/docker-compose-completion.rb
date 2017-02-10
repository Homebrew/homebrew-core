class DockerComposeCompletion < Formula
  desc "docker-compose completion script"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.11.1.tar.gz"
  sha256 "d00a261c08ed664a068a7e72f1a89dc85fc7fb32b9af3dc4b25e414a7b3662e4"
  head "https://github.com/docker/compose.git"

  bottle :unneeded

  conflicts_with "docker-compose",
    :because => "docker-compose already includes completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    assert_match "-F _docker_compose",
      shell_output("bash -c 'source #{bash_completion}/docker-compose && complete -p docker-compose'")
  end
end
