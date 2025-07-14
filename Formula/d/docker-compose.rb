class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.38.2.tar.gz"
  sha256 "250e087aeb614c762e3cb7c5b0cacb964acfa90f3f1d158942fc06d22d5e1044"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d430275d6426852c30c242b943182d84f3f74955182e918dea6a3e4cbfd02627"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d54de4b898e21843c6b555030fadcb2055aa0daa2230cb5542624369eb23f525"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acb4bf6a7a06a208fcd77e704fd34334b7c69a397302856f29b3a3255d766df8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a5b53a3b323c0537f287b5ac02795ab2706263c4456058e4b06e6811fdf1508"
    sha256 cellar: :any_skip_relocation, ventura:       "d0a35fa5d7e1357cf1912b075bf6d935b7d31084e791acbdb8446fdd6a65f4fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "639c51ba5c6e16989a34f7e75e962a87ee662b9cc1bbed20b5cbb7085b25ad6b"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-compose"
  end

  def caveats
    <<~EOS
      Compose is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
