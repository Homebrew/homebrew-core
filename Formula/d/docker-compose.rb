class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.27.0.tar.gz"
  sha256 "29b2232d1609dff03db74188a7944c85ba8b612f47a7e39938a43db8fb7d7067"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd0684e5d76a8e30b7b1e75742321f1cfbb957f20d2f89c516a73bdeb7e9a078"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c19d4c3386a59eef45f568ecf670d08c4e05cb537e839f7da5010b6a95a1a15"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3b7075d9834d86d4d80154e4df0843a767efb4a56da4a7f76d367efabe6ced3"
    sha256 cellar: :any_skip_relocation, sonoma:         "eecda9ef02c7df206b12c1f164e4e56d809dbec34d005e6a94caabf6e5c02d4e"
    sha256 cellar: :any_skip_relocation, ventura:        "0b24fb98947eddd4522805d4e762fdcb0bb7dae43bc269c5388f676cec989def"
    sha256 cellar: :any_skip_relocation, monterey:       "5ace3b80acbd509b5025942ed6da23e900741937d894769fbf00e5a15beb6c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "674dd5b14b746fc03e96301940a6368c84a835c4b38a615d283d7be82b3cc8f0"
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
