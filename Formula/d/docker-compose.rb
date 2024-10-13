class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.29.7.tar.gz"
  sha256 "01b759bc7c301096079dd51c5573751fe7b08ebcc7fde46b40d318539b0d4d8a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fec60e18a885eed654171248bf1a672688f8581d9dc92be4a402aa9d544681f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5dafd3e14515efcb0d5483cec4e57c4535f986224c4ce3b4fdb2a2eb1f70e3a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4524d495e11c3107d58215928ab6188fc04735f932fdbefe7878882e739b5ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "80ec4c7da0be0ace554f976632623f3f73b5ced807b6219dcc874fda894dea04"
    sha256 cellar: :any_skip_relocation, ventura:       "31c6b348ea1abe183f374f458aa2e7a8b85d24b9e52030eacbc9431f5ed31aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "935cc321434eba691117c31e1e5937df77f01400cdd1fd966641d795250267e9"
  end

  depends_on "go" => :build

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
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
