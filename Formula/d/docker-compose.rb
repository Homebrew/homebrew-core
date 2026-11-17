class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "1836019594ad054f8459cea7efc1d52eae7d05c64217c4efffe02d0d2930c44b"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b73adf4f57aec759bcb75773b345847572a148b552913963e129e75fbbf189d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b79facc573a02e8f9ab604cc66cc7bb54825935eae75a1e3b0c9c00fcfd60fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "976e20425fb22d0f3f5070b506c80a761807aa342ae7231209c694ddc6c2866e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "01293f8ce1a37d92f4d34f2b068dfe2ccbcb5c62e2883700027c8829b4622667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a092ee9c21bd6688915feffadd53346950389e1647ec44d12f2faddc09b631fc"
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
