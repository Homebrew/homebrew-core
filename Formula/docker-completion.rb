class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v20.10.10",
      revision: "b485636f4b90ed5a91a1f403e65ffced469c641a"
  license "Apache-2.0"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d20490f91f0be60c2a6cfd45ae6155057b0ca21e419cd4332fe61b9fd8151d4"
  end

  conflicts_with "docker",
    because: "docker already includes these completion scripts"

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
