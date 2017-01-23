class DockerMachineCompletion < Formula
  desc "docker-machine completion script"
  homepage "https://github.com/Ketouem/docker-machine-completions"
  url "https://github.com/Ketouem/docker-machine-completions/archive/0.1.tar.gz"
  sha256 "0b76cace0f71043c768e6ebc84ad424c62e70f2557c70389d7440ca71b1e3482"
  head "https://github.com/Ketouem/docker-machine-completions.git"

  bottle :unneeded

  conflicts_with "docker-machine",
    :because => "docker-machine already includes completion scripts"

  def install
    bash_completion.install "docker-machine_completions.sh" => "docker-machine"
  end

  test do
    assert_match "-F _docker-machine",
      shell_output("bash -c 'source #{bash_completion}/docker-machine && complete -p docker-machine'")
  end
end
