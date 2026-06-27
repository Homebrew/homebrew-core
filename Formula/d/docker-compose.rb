class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "7bc980b6a73728372f7123ec1e2908fc30a4b0c2ff6096d8229853742117b205"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61f3e000d2daa0d07b4be884625d5a2759f46b39d6ac6fd5acd1b152520458e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc0d7dbd3fc0f9e6a5afaa2ca4ade0c8aab2484ee557924cbda7bd1f1df8456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "975984afd9fb6a3fc4fd3568de43861f36e3dc32ca6cacec2477fc0d889169f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "18da172bfed780223cd278b1c397f94cd7494ec4672f26167ff244c448dc9e22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea19e7e730ae1d31717d8aba4c5864ba4ec194790a20ad55ac1adae43a5b0ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85b38831ddd2235cf60a50551ac702d3252593d0d16a6b4bbd2e09b24a70cec8"
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
