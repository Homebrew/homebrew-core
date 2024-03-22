class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.26.0.tar.gz"
  sha256 "b42bb6b118b664db8a37a160b4b3782712199fedd35731a2314b5762b2700d3f"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2bb7e50ec4b602f4f78a7f8bcd5d7e435be6c6dee43c03608f1562e4a28e31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad5b5e14872eb84b400de3a23ab09e1e758b17b85efd6c24e8f453013dab56a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f13ac0d38be6ababe2aa995194aa11192befc6d1b20e7c0be82080d09676db"
    sha256 cellar: :any_skip_relocation, sonoma:         "6841e9a979852c6581e1c39dd853cbbcceffa649c53ca19afd926bb6dfcec50f"
    sha256 cellar: :any_skip_relocation, ventura:        "a5122bf80ff898671bc9041ececfa3332bf534cd02137fd3fa572e7eb8a25849"
    sha256 cellar: :any_skip_relocation, monterey:       "46625ee2ec778c4125923454eab7a78e0f5f3189385cf81d2c068cde61ed6f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f5ab8c9256f507e388de249f98d9ddd99e8fd1d6ba1ca304b81360b985325eb"
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
