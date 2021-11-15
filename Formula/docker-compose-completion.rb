class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.29.2.tar.gz"
  sha256 "99a9b91d476062d280c889ae4e9993d7dd6a186327bafb2bb39521f9351b96eb"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "daddf263b55ef91e97b0fe1eadb0887bce2c3dda6eabce27a30f775dccedf43b"
  end

  # See: https://github.com/docker/compose/issues/8550
  deprecate! date: "2021-10-02", because: "no upstream support for v2"

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
