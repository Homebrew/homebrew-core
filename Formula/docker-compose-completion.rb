class DockerComposeCompletion < Formula
  desc "Docker-compose completion script"
  homepage "https://docs.docker.com/compose/completion/"
  head "https://github.com/docker/compose.git"

  stable do
    url "https://github.com/docker/compose/archive/1.19.0.tar.gz"
    sha256 "2f8eb50a1e71a9eed773456267d511cd77a463809e746d02d9366888ff30d8a2"

    # Remove for > 1.19.0
    # Upstream commit from 9 Feb 2018 "Fix bash completion on systems where
    # extglob is not set"
    patch do
      url "https://github.com/docker/compose/commit/56b2a80d5.patch?full_index=1"
      sha256 "eb4a8f2c407fb129464b249f1f50ee21672ca1d0addd401d6f5c933fb9ce82d3"
    end
  end

  bottle :unneeded

  conflicts_with "docker-compose",
    :because => "docker-compose already includes completion scripts"

  def install
    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    assert_match "-F _docker_compose",
      shell_output("bash -c 'source #{bash_completion}/docker-compose && complete -p docker-compose'")
  end
end
