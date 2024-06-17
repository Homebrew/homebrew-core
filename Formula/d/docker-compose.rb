class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.27.1.tar.gz"
  sha256 "5abf8de3a413894c2ed061812d68c8d8eb4e255b25bf38e2ac58d3ba0546a218"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed2cb9ed12395de75e6cb3c26928b1d4cd0453e896dd7712dc6ca0d688f7a04b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19afaa8b200b4847eb170c7b0bb04affa275b16b59374f8eaf981e1360d9136e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c946843d5293c97f0dc91ffa658a8f4b2982c882e960985458d311899e23d81"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c0595770d67817e503d47a6907b3862742b018a006651e0f7470219f7f2c866"
    sha256 cellar: :any_skip_relocation, ventura:        "4e59104c7454f63c10f0de3900a733f6c5bc04e069fd0dcd05bf8b788085c248"
    sha256 cellar: :any_skip_relocation, monterey:       "48a1edadcfc942fe8cf9fb4215ff55d9cfb32c34485f87dcfdc1cff3a4fbc737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c81dbd9238b27d76af509423801515a0470c8fb8722b0a56855d358954c358f"
  end

  depends_on "go" => :build

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
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
