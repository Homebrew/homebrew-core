class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.29.2.tar.gz"
  sha256 "99a9b91d476062d280c889ae4e9993d7dd6a186327bafb2bb39521f9351b96eb"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "edaaa7562b5ef5255da64daa17a086a2c8c45fe2114e7704047b15f155719c1e"
  end

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
