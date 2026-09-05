class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.5.1.tar.gz"
  sha256 "311077662698fd8e34769a894f9d5240befb1730990efa8ed58e0fa8725d2d84"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a4eb648b704910aaf8cb2239a6337aa74ef598aa3bc7274be3b6328be8e41e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6286a304f0fc0c991bde518a6e776fe62593423d0ff195ca2bcd731b4ec4b277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6d1693d1836636bb6b10ef82b70b3095f82c2545be06c6ab74b03cb6a03f1bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9605e3198f73e0a3bbcec3ccc7082ca1061c6e97877cf3a37f696aeae494857"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20409c9abb849e4fbb832b33da57f4fc812a4a2036b772306a8b0a6aa23879c"
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
