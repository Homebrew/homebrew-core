class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.8.1.tar.gz"
  sha256 "5ed75d95a0aface6495a2aefc0a46c1fb56d0889abdf0840dc02c372a2ae7430"
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
    manifest_sha256 "e29575c66cac77ab3f9a49b3831aee1616e11751b0d9b3df38023ea2916a0efd"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3b0e077a8df0e952f5ca040c6c171347bf04564b811af94123727d47bef3a170"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a5a4a966e9c32cfd35c886735f2cb5301b176a63b9c7a1bdc279720b98867a92"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd97ac3447b1125a0dfa92d109a92a387d3d5ad9a499c3741c78a6da51ab067a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dcece0cdfaf93c386d945f697eaf25ab2f0b8516f07909721826897710701854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "53f3ff3dfb7d50a3b1ad2621b336f053047d90f24af7c8ea148f0bdd9568bbf8"
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
