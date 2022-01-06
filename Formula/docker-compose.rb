class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.2.3.tar.gz"
  sha256 "22210187e73732edd9fc02f122ea61481806c703af7b73d0a7351f2e8ed7c0b8"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aeae98ecbd8fbc4723f07084dc4bf321c878c33602e96f44fd5fd117dbefce0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6aeae98ecbd8fbc4723f07084dc4bf321c878c33602e96f44fd5fd117dbefce0"
    sha256 cellar: :any_skip_relocation, monterey:       "4e8a9b44a711e5adf55e0d98160f202bfc2de1a71c5d95f8a0d2055a67d16c4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e8a9b44a711e5adf55e0d98160f202bfc2de1a71c5d95f8a0d2055a67d16c4a"
    sha256 cellar: :any_skip_relocation, catalina:       "4e8a9b44a711e5adf55e0d98160f202bfc2de1a71c5d95f8a0d2055a67d16c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93f02a4f7053c602cb929c3886bab80d0f2b77cdaf002fe4767c4055a520ce3"
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
