class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.2",
      revision: "cb74dfcd853482dd43cb553106b1e0cd237acb3e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, ventura:        "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, monterey:       "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2ad36e5e1e235663d52874d336daf5486532c696ab1505648591c2c1a4babac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf20b7a7a4d849791fe37e41c14cb6f56cec267b3bb0b28d9c2c1f7a5b4c8de8"
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
