class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.32.4.tar.gz"
  sha256 "2574c30f5746f43209b203c1acb23c26a92598944d990c12eafecda663b80e9c"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70525b92ab7b8842796b374a4fbb9c6f9d47a4af3679029cd25fe217027838cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "585a82a7a2b9a25643b6a2cfad8d54d090143c387e412eb80cee16d33034c40d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "29c271ddac69fc2bdec831adb32e98186b264eee0ca616ac7db7c0aab7088196"
    sha256 cellar: :any_skip_relocation, sonoma:        "7045c80dca5b5981cea319fee6dcafc7ec89fc6c9980f336519ce364d5acfbc1"
    sha256 cellar: :any_skip_relocation, ventura:       "65b382012b8de9c20f311b8041fe0f146eb32c4d46653ed8af345cc063d263bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "821d3bbe4262cdc45270105e6d9cd78584dee53f56ea1c3bedd745332bf976c1"
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
