class DockerMachineCompletion < Formula
  desc "docker-machine completion script"
  homepage "https://docs.docker.com/machine/completion/"
  url "https://github.com/docker/machine/archive/v0.9.0.tar.gz"
  sha256 "8e445e70a92c98a5e73594d8aea07b31dda6fa4ed2d1e7643663f0267e05f25f"
  head "https://github.com/docker/machine.git"

  bottle :unneeded

  conflicts_with "docker-machine",
    :because => "docker-machine already includes completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker-machine.bash"
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  test do
    assert_match "-F _docker_machine",
      shell_output("bash -c 'source #{bash_completion}/docker-machine.bash && complete -p docker-machine'")
  end
end
