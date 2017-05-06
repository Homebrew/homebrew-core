class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://github.com/docker/docker"
  url "https://github.com/moby/moby/archive/v17.05.0-ce.tar.gz"
  version "17.05.0"
  sha256 "4716df117d867b82ddab2e82395cd40aa3d0925a689eedcec8919729e4c9f121"
  head "https://github.com/docker/docker.git"

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
