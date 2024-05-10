class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v26.1.2",
      revision: "211e74b2407f24fd305907c8f90430a9f465df66"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8bd30a2df4632c7a3a3c9b4ad995a0afe6991ff50b8059030532dd499917740b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be8be22adfec4b3273c38e77d55301ba0054aa66781d93b2c62fc49c8c808f5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15284598e154fda9e88aa0a2357f39f6eeebcc2145fb47ee486daefc03c6a6e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fd2f3ee4c807ef6d56b74f2573d03d1f10a0042265b02feb9e98e4807eeb6d0"
    sha256 cellar: :any_skip_relocation, ventura:        "4c1b32c5804d2d2d08a9d24718f9a76c22d752b47daa712403bb128a072161e9"
    sha256 cellar: :any_skip_relocation, monterey:       "92fdd6e20d397db36ebc8a0876c5a8974c1be3ce36733f4b8cc21f3701081846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf54c0c2624d090c2d5ed16800431327a74f1d82654e2166bc0c2ade6766bd71"
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
