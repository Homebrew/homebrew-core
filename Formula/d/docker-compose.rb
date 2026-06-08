class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.1.4.tar.gz"
  sha256 "363ce6ccca46f836648f5f4ec9ecfdb6f631daa126570cc3fc69140edeed6794"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f168e11e7152a10266336d79e1b3bff13fd7334a41f654d30e55a714b3dde6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b182b7cd39c4309112627c7014253aeef19a934f1876c68c1d19419dcb25cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e53db8ef5a47a6931a97ea1610314f425b9a7abda371f6dc9307d868972ffe66"
    sha256 cellar: :any_skip_relocation, sonoma:        "54dfb611519db44e990d5a8113c5e746a95d874efca6f1909b0c16a4ff256b64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1db0df21e2c8fbe0408dd96feac03ef8400651cf2fcf5bb8a884348e81ecdafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7434d8e07ab042d1973d69a3a568530fcd3f2f4d8a4a3fcb64eb43c50d0d8730"
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
