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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dcfd580ce0f39860f77870fff595f68f040def6fd1015d7307916378034bccd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1793acc20d286e77f1d4f654095d16f397fa1d5ec08732103f602cdb1bfaed7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9745e82b5ca49600e9e71565baf539b4c66c996204d4cc9d18905eec26ffa85c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b6a5b839301906f22201e180df468eb3ded0de172d7dbe797b14b754dddf8096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "15a72077efc3b55fb7641c09602296499698623941730d6506ae49963d834648"
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
