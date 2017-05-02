class DockerMachineCompletion < Formula
  desc "docker-machine completion script"
  homepage "https://docs.docker.com/machine/completion/"
  url "https://github.com/docker/machine/archive/v0.11.0.tar.gz"
  sha256 "a29f8f028cad2525c016f5ca6b14a4fd5bf5feb15eb9ad902696991385819e91"
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
      shell_output("bash -c 'source #{bash_completion}/docker-machine.bash && complete -p docker-machine'")
  end
end
