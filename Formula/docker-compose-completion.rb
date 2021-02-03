class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.28.2.tar.gz"
  sha256 "f2c4fb33fc4368b4ad4452f2de82d8a37d08e46f9bf45aa3c0cacdbd7846f69e"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle :unneeded

  conflicts_with "docker-compose",
    because: "docker-compose already includes completion scripts"

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
