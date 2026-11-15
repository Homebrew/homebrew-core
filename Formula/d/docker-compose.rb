class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.7.1.tar.gz"
  sha256 "bd108789759d3e17ae5532dd6eee67b427dade4c85089daa2f85d6c8f3e3ccb6"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1efadfdd1e58bf24cf4d80538081fdbdfac8b2d1bd2c8e6a973ad480763cb629"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d07dd8d1ca4057f5b1cf673167662e52f53f4bea3d607192ab94174f3261f94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fd810cd786f387886e463a7c17c3dd3d1930c9efb76ddb3faf8f1399acd845c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f6bfde123bd661bf9bdaadecbbfec3ce2e076b0f64041f2f805eb56e62aabf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8a603a07277cd91c3b24c7c9906578288aebd74977fba66f8c6ba652a879d508"
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
