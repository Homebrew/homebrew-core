class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.29.2.tar.gz"
  sha256 "f040319023ed33d48aef424f7ac7dce720d5733c513216717044d658bc3782a9"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ba560fe16ecce6a672583c04b0627e4ae3d3b0f29d3b9568393c01372620562"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4624c6b01fc315c6463591136d31bdeb34552727df283be0374802fcaf2ea490"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ec964f44372039c0e2f8eb79d7e1858d0caf2797b59f22a2a2ab2b764b0d7fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "9ca82a0ad04497f344b89578e7c84e2454f2bfea20d680727416b63b148ddd45"
    sha256 cellar: :any_skip_relocation, ventura:        "cb8cd96ff9d7416e67799c383b6d88f1844ad951b4c5c79d56544159c8ffc334"
    sha256 cellar: :any_skip_relocation, monterey:       "db28f641758dfc143310fd6eff6f7dca78562bdab1456216bfd2707196003a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3cb69f95ae2401219e0fb51666fefbe5d9aab51fd97c3fb2e25c290dcd73ea4"
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
