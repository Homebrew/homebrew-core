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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed4d83eae8c854b5654e8010377b786ecd59d1968093217dc0ca6f4a37b59958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da792e02fc30e72174782f85ac32f474cff6fbcc2a28d8d179b2ee2d59ca681c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a83dc20ff4e53f24a988e0339162641a7b5a9bf99742487530ec003ce47c6e73"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe086d302aefeb54f8bf3d99833c77b1140b14366b5c6688e61eb57c777eac52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13893ab3953b8fd045e8d8c0b80bd5cba3f04f43462024bbc8a727a7ad5fd9a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2af5a767cd2a4d4fc7a3e6bb9a782f7ccff30c3177f0de024c9a79adf587911"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v#{version.major}/internal.Version=#{version}
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
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
    assert_match version.to_s, shell_output("#{bin}/docker-compose version")
  end
end
