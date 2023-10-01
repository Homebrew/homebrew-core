class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v24.0.6",
      revision: "ed223bc820ee9bb7005a333013b86203a9e1bc23"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, sonoma:         "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, monterey:       "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, big_sur:        "56d82aeab03f3c776a4f0267d58b178124a3aa3b73d8c203ef875b772aae5aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa325b957a53a06c185270c66685e7779f40d51913b309bf251466e98b92dc59"
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
