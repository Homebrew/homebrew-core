class DockerMachineCompletion < Formula
  desc "Docker-machine completion script"
  homepage "https://docs.docker.com/machine/completion/"
  url "https://github.com/docker/machine/archive/v0.12.1.tar.gz"
  sha256 "5da636dda6f048709dfb65a371fc8429151c52af4f345bdaa492cb1952bc0ccc"
  head "https://github.com/docker/machine.git"

  bottle :unneeded

  conflicts_with "docker-machine",
    :because => "docker-machine already includes completion scripts"

  def install
    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  test do
    assert_match "-F _docker_machine",
      shell_output("bash -O extglob -c 'source #{bash_completion}/docker-machine.bash && complete -p docker-machine'")
  end
end
