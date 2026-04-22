class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v5.1.3.tar.gz"
  sha256 "19c7219c97390473bb96530153e64fce98d4b05ecf6f73016e564201d99512e7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc0828bedbb05f3f4b043aca1a0c0331e7ee2abef03e0ef8cfce40ed85cdf6d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfc46d3774dbf745bdd7ecf96e404e732782acb34abd031713dd2df211d8766e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99f5dee9c43dcd51761dad12b5509d6aa5532e38ebb534c36b4b584e71f0a4f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f10c692d1458b20b5dd1ec7d02d04acf135e6001b4122fea94c80f1794da943a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd87074ef519d79b103bc7d9851ee9ed95cf3fe1457d410a3a0f154c5dd92e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7755df3eed96e1e19e841ce30ef3d06fba19c439fca77ea9175a9967fd7e554b"
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
