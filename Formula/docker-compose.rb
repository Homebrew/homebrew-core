class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.10.1.tar.gz"
  sha256 "75f284d61e97410357808811cfaad8a0a168911877d7dacb6daf4c6725ca2495"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9efd7c510de3ccb1e4417c02543518c1e104def1dc7fe3add8fdb604522c787"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9efd7c510de3ccb1e4417c02543518c1e104def1dc7fe3add8fdb604522c787"
    sha256 cellar: :any_skip_relocation, monterey:       "2e93919f4e070a6cf792e3d47f0224dcaa328e2844b7c82f5a8ab0e013891904"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e93919f4e070a6cf792e3d47f0224dcaa328e2844b7c82f5a8ab0e013891904"
    sha256 cellar: :any_skip_relocation, catalina:       "2e93919f4e070a6cf792e3d47f0224dcaa328e2844b7c82f5a8ab0e013891904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9c6d73a22c49facdfeae939c6ce1130258e1d1afada77c1872e52166d9cbb0f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd"
  end

  def caveats
    <<~EOS
      Compose is now a Docker plugin. For Docker to find this plugin, symlink it:
        mkdir -p ~/.docker/cli-plugins
        ln -sfn #{opt_bin}/docker-compose ~/.docker/cli-plugins/docker-compose
    EOS
  end

  test do
    output = shell_output(bin/"docker-compose up 2>&1", 14)
    assert_match "no configuration file provided", output
  end
end
