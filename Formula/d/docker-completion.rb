class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli/archive/refs/tags/v29.4.3.tar.gz"
  sha256 "e9341f05882778096d85f8cc34222b5b731bad9561980c377b9e8477dfb1ebc2"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ef19a37f309cce65ad8155e248cfa31b7aa41b8c9001fc3fdb9c62d1fc734ee"
  end

  conflicts_with cask: "docker-desktop"

  # These used to also be provided by the `docker` formula.
  link_overwrite "etc/bash_completion.d/docker"
  link_overwrite "share/fish/vendor_completions.d/docker.fish"
  link_overwrite "share/zsh/site-functions/_docker"

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
