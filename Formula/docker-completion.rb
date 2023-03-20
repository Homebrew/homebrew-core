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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3555e9248898bdd464d014e2b407a1c50d1fffbc5849d399491388b3f3afd14"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab5db1638b7358f8ecf4f127f334c6a92514998f4740307b1f6ad7c9a7a4ca18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85f44be039ffa24774aaa863cf6bbef74db8dee374715f3f0eb47f4ebd76f374"
    sha256 cellar: :any_skip_relocation, ventura:        "3f87217481df0f63df2eb87b69de608a6a5f97c19a8664483430665667b4c7af"
    sha256 cellar: :any_skip_relocation, monterey:       "7aa00ac7c25a54a414435f02338a6e47d0c51dff512b47ee43d7f39eb3e96ea2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cea4dbad3f0da3826ca2246ca5b111f22edc24b902f1ae9b1da1fad8258a27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc8118673272b25b1944f3b714f14f2800656fb1085c1ac0c9523af8c2bbc01"
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
