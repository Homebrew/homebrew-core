class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/v2.0.1.tar.gz"
  sha256 "5a1b1fdb9681c6f4b39fceab7d7dca12285e72cb55e3d35c31f4659cc939cd2b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "daddf263b55ef91e97b0fe1eadb0887bce2c3dda6eabce27a30f775dccedf43b"
  end

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
