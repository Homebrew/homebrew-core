class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.0.2.tar.gz"
  sha256 "9cd91c987bfe5924c1883b7ccd82a5a052e97d0ea149d6a00b2a8c3bf3148009"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a07dbf37dbac45c75c2542a42f613f919f1eb622e7cd1828e82e1d2731a87bf5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2b20efa8c6288da16d59c32780244af8d1d90605a0ca6e688080913eb1ec43c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6189f2ca577c2e8176365c76f1452d025efb47f9409fd80ee1b711d37e72593"
    sha256 cellar: :any_skip_relocation, sonoma:        "422a0e8618aa5bbee703be3082f6fff599e69b5a0c0627612175cfcf199a1b05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "58d3a5a787903a32e883f74f59357ff7a169811448749a65640ee2b7d27f043b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f366a89330d5ba5581ce7d324543820064e0a86723ef0e9cb50f181758c9a63"
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
