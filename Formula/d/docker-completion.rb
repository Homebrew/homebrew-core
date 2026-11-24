class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli/archive/refs/tags/v29.10.1.tar.gz"
  sha256 "64701a1a4a2d3906f43809cd7b8636246e73432715d1fb279c35b18bca0e4b76"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    manifest_sha256 "a688e0a9a5c1c3a74168d9d325bfcddba3e9284c7ab104cd63e04dccc230beca"
    sha256 cellar: :any_skip_relocation, all: "f1f65db149d01d3807e1ae20fd52cc7b91baa8636130ec48a886cd4f70739332"
  end

  deprecate! date: "2026-05-31", because: :deprecated_upstream, replacement_formula: "docker"
  disable! date: "2027-05-31", because: :deprecated_upstream, replacement_formula: "docker"

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
