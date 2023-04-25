class DockerCompletion < Formula
  desc "Bash, Zsh and Fish completion for Docker"
  homepage "https://www.docker.com/"
  url "https://github.com/docker/cli.git",
      tag:      "v23.0.4",
      revision: "f480fb1e374b16c8a1419e84f465f2562456145e"
  license "Apache-2.0"
  head "https://github.com/docker/cli.git", branch: "master"

  livecheck do
    formula "docker"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, ventura:        "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, monterey:       "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6b5edf15a0a57fc24da36262f95904d9070976eb423408d5063cfd7f59c624c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "999b62a11392bd7afd9c13872a85c647eb7bb66f6631d2fcf1a6fb8bff76036d"
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
