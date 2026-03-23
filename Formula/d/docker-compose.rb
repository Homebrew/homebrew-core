class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.1.1.tar.gz"
  sha256 "32cc81d0a79004c10c6c30052ad96d0a8a72c7e22412aa80da1f8f4c468d3dc1"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "716f6a211e08e4f647e90e6cee4f08b9763951b833a0000279bd6df40a412d17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd44dd0e422c78578b4dd5783d98397d5340685b568d46f3c86523c33b6c027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ef0934e94c85a14cceec14e54d3ced69eded8a84777d975003a75785934fd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3d45e8c3778a64a4bda2dc4f4e9472e76e8ec8be276af8b6ba51a85977711e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f11a9edc0ba131e81c745700a006e1f1a82d074c11d872448cd0c8ed5e623b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053a309694de7bbca11118a83ca0382d94917f87490da0dd107e5df0ca724635"
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
