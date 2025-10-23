class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.40.2.tar.gz"
  sha256 "e42df0f5a473cb7af15b12daffb66584a2de294e9441795b1b2b79594d2bd2d3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7a566d8c60dd28e5652e26c8150185578796d32643ff80999e62fa3914cc807"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56f9c2e268208e4cc0fd1e9786f5da016d1e8719e74ede288fa7afa4fd407884"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11b9445b1fcf0dc99232e9e4b2b383f7cbb7bb9c61f5e029a60ff09f0ca8f2ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba9716f8ad90f0f265e764e685f730414d9d1b2d1f54bc1b16b6c88c774ee22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e3a6c1621163e989e872115d932d02fa540dd520c196cbb2175fcf375a875ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b67f84ecf6f7926e1811dfad68d80469b32fbdeb2c356b367307029ffba3e961"
  end

  depends_on "go" => :build

  conflicts_with cask: "docker-desktop"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
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
    
      Note: Some Docker configurations require an absolute path instead of the variable.
      Find the correct path with:
        brew --prefix

      Common paths:
        - Apple Silicon: /opt/homebrew/lib/docker/cli-plugins
        - Intel Mac: /usr/local/lib/docker/cli-plugins
    EOS
  end

  test do
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
