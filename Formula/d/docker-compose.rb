class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.39.3.tar.gz"
  sha256 "3888259a6a212ebbdfd8762f394ae5beafb98cc383142cce46eb27cbc36a5d9f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4abdc6c2e84338568c21721ff897b2715bdc9561af29f8c3dcb22cf924747f79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a594fde55e9a2c676bdb142e0b2b11cd81a8bf02216d46f95881ceca7f2291d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5e0c5f0957e1324a9da1cc05fef3753ec7dbb4bee79d8d9cd6625a3a5d2ed7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "802566285b309590bb8a3431c79577dcc94f6264810739ec6fce260846a178ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c030c2d49c1c8cd5ec7d67dca81eeb174a3ab4df8eb00b8c12ff78d399bf283"
    sha256 cellar: :any_skip_relocation, ventura:       "a7bc90097b057cb004b2941cb824de287e117254de13187e7f2bb9ead1a018a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e78ab449d126f679f68ea3766642aa756f84afa71fe96ffcb62cc38141b36fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91e6a21b0b9a59609136a57515f60b4e857679b10581ec6d5ba0d49cc04f92b1"
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
    EOS
  end

  test do
    output = shell_output("#{bin}/docker-compose up 2>&1", 1)
    assert_match "no configuration file provided", output
  end
end
