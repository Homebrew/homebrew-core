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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b6734571e0d151f27d3784c19a7aaa532ccbc5bb6bde6e85e599b56b0a9e6f2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d27bee17acc693ddd8135662f2f4cea06c004df351bda147a70359de3a9656db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d99a1a42c7748860020f4d044d30d294a300fcea4dfe812e71ec04969be0914"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8127b5fb1a0c6a9e74b4120aab67049eb733d5ab913fafabf674a7e673868e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c031331174f312c73d2c8ea6e250826e1269ca9655e32b81a3dac1419e73af40"
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
