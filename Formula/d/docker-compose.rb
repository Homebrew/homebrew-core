class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.36.2.tar.gz"
  sha256 "a093a9bbc646f3f6772eb4e2096a3df02618b394568325e4972b9382b0dd67e8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d981a6f4c0881ea03fe265d3832982e73eb948e0acba5582568b6655b1714f1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3bc57871266692227c0fd2547e6c4aa51ae6c5b7e6df8f0abafd74743b2ed90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36fa203d8255cfa431363db6b2a565a77b82d01684cbfe77737328ae24082ba2"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a210e3bb7333ac18a057e43403a697cfb14f20fb838ce267327a47c79fc00b"
    sha256 cellar: :any_skip_relocation, ventura:       "8fbd9f89bfe1ebd6ef6896363bc0d92f9b35518c1d3eb09cf63ce2d8f4f1981f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82b32a0c7bfeedbf9455ab5723c7fd7c335f206c2cc8e01f557b9eb128721e8a"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker"

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd"

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
    output = shell_output(bin/"docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
