class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.7.0.tar.gz"
  sha256 "98f5b7dd4a66d8a2d9289e918fa0f63e5ff9821623950e53e633571a78b30d63"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58245ee987c2697ecfa0952afe8ef9597c26e998a8d5158fad023cc46ee55f78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a9fae90e8999f01d164cd359b70f7be7e30662738ba649b395ee59c056e0292"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a8a12fa3e12a6c0fa07ec4cd7099d76cefb764927907fa9c01db97cc0c4a0c14"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "259a283844d6ae3282687acba2b975c6e3125f0c0821e31ab5c00d70c163ec3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8a0f1cb77bced4b600ceedb31f09e1541a1ec259b6f7da84e6cc351c534ff627"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/docker/compose/v#{version.major}/internal.Version=#{version}]
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
