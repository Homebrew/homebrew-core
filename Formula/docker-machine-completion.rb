class DockerMachineCompletion < Formula
  desc "Completion script for docker-machine"
  homepage "https://docs.docker.com/machine/completion/"
  url "https://github.com/docker/machine/archive/v0.16.2.tar.gz"
  sha256 "af8bff768cd1746c787e2f118a3a8af45ed11679404b6e45d5199e343e550059"
  license "Apache-2.0"
  head "https://github.com/docker/machine.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a953e0a6776024c35f839a0f4a23a782e186318fd07fdaa0a8405f41fadbd01a"
  end

  disable! date: "2022-10-19", because: :repo_archived

  conflicts_with "docker-machine",
    because: "docker-machine already includes completion scripts"

  def install
    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  test do
    assert_match "-F _docker_machine",
      shell_output("bash -O extglob -c 'source #{bash_completion}/docker-machine.bash && complete -p docker-machine'")
  end
end
