class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.1.2.tar.gz"
  sha256 "9fbd031a82180c82fdfdd823a615c607bdb92cbae035c4481aa073a76749f57b"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1997192ad9987f379f74343c6f064b08238e6091430f5b1ee014885511d73b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47704416d81729affb90226460e4ceee31bbafd436fb2bec82f8ee99572235a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7868c5b36b02d1ee05635e7b4a365997d7e7ec3ebda9e36da614992ffaa59e40"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a30d099cb427e0457e931474d36b4173da037c96135d8373ab73078273e2b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b76da41028b8ee417345617758086215908b6428a6113b104861f1b88ccab95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801878e87d7f9903b053e3830cb81ac08f31968d07e48b64d75f9fbe66731006"
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
