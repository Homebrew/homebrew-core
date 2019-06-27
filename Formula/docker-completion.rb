class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/docker-ce.git",
      :tag      => "v18.09.7",
      :revision => "2d0083d657f82c47044c8d3948ba434b622fe2fd"

  bottle :unneeded

  conflicts_with "docker",
    :because => "docker already includes these completion scripts"

  def install
    bash_completion.install "components/cli/contrib/completion/bash/docker"
    fish_completion.install "components/cli/contrib/completion/fish/docker.fish"
    zsh_completion.install "components/cli/contrib/completion/zsh/_docker"
  end

  test do
    assert_match "-F _docker",
      shell_output("bash -c 'source #{bash_completion}/docker && complete -p docker'")
  end
end
