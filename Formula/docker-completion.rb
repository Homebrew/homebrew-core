class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.6",
      revision: "ef23cbc4315ae76c744e02d687c09548ede461bd"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, ventura:        "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, monterey:       "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, big_sur:        "1039410ef2996b15fafefcc85e9e8085600ecdadc175bd58e43f376400d58f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fef17678ed7557ec87fd445a8752cab70a22bb77b24dbf080f8b7eaa36d57151"
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
