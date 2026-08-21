class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.5.0.tar.gz"
  sha256 "504ed1541f4bc5c301dc9cf7b86ae8e2d26b57a558a248d9b832af188b298bba"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c083ba0e63eee3c81dd62aaff61e6f485d6cc66ae1f6887da82b8ac75449c2ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87babe68cce186e09b9b53e650e9421e01d0a2fb0e51cb5bcbcc7c01860cc4ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9125be4b1e07ab1a90c36891917dce031d2377d59c61a350639fae456e2d65ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "0786e339e6b4d309e21b808b86db88d518cce20c2702f58e5a467af2aa2a8cdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8b778825c59efae7699e949f9f633b3af9b599b4f06d8581db2a322a6398ec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ebe987ffe0310687345b08109e24bcc3bc5c63333939e8eeb2651e784febe9a"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

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
