class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.3.1.tar.gz"
  sha256 "1823e1b09c4082779fdf5cc9f3d8453b95dba3d939105b39366175ce12fdb6c7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df565543164437312a50347eb2785b59b0f35e9fc1c044aaea5b6fa78952608"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62625418b24ecc6c69e22de8c73aeacaeae6d0243c2cd984ec285aea2a574eed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0c7fe4ad735bbf2da230ffa5c40b3f6df7598b4ea26315e075fc8fc1980de0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "40a97dc30b915d5d6102481e7e90f8275d24b25e8a558afbc0f03dc57f27344c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4883c66d0a0c68e4c667f24e43e0907c38f0264b97f165d38d1e38825fed170e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "697ee512678ac0b55df2d8a635cd632b36a7adb148765a1e65ae95a1e1be0c3d"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
    ]
    tags = %w[fsnotify] if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd"

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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end
