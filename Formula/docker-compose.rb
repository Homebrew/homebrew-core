class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.3.2.tar.gz"
  sha256 "11c1ea791698ec04c56d69207cf7b256e11b8dd2b4ae7b21cb5cdf875f5fe00a"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c521297e59264d5687b57780a45d2d7f8aa00c037527876f4f8c4bf6cf704856"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c521297e59264d5687b57780a45d2d7f8aa00c037527876f4f8c4bf6cf704856"
    sha256 cellar: :any_skip_relocation, monterey:       "465a709e83ec012bbd4fc0c860119f4ab6bdd9ef84f79d388854a377ecc0f968"
    sha256 cellar: :any_skip_relocation, big_sur:        "465a709e83ec012bbd4fc0c860119f4ab6bdd9ef84f79d388854a377ecc0f968"
    sha256 cellar: :any_skip_relocation, catalina:       "465a709e83ec012bbd4fc0c860119f4ab6bdd9ef84f79d388854a377ecc0f968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a04c6b91a1f2e7aeaff2ee9538d773f8b2998b82b0e0b54d69c84bcec4c6b1c"
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
