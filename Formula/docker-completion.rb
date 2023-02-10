class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.1",
      revision: "a5ee5b1dfc9b8f08ed9e020bb54fc18550173ef6"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, ventura:        "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ec972bb979426aad54eec58cb5592e0f2e26deab5275e31b8c0b3ae50b0ef1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5b8ce029a88eda55d4d382c239ae42bc1b1edd70f4bbee81c0841919c1cea6"
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
