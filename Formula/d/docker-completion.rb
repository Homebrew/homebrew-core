class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.5",
      revision: "ced099660009713e0e845eeb754e6050dbaa45d0"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, ventura:        "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b77b6d4980dd2c9345cf64b9a790c0ac177358195d19202a06112b19b1533a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b06e653bcc94b075f045a4f6ed6eae427744ebcd280e435692ef90c2d4b1a4c8"
  end

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
