class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.16.0.tar.gz"
  sha256 "556dc59075280442128f5b45a8ff37638fb357c2a956bd751dd0ba747c93e71d"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5a98f65522c824dcac6627b46385063e0049bff3c6f94bef21987c85c450bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5a98f65522c824dcac6627b46385063e0049bff3c6f94bef21987c85c450bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f5a98f65522c824dcac6627b46385063e0049bff3c6f94bef21987c85c450bf"
    sha256 cellar: :any_skip_relocation, ventura:        "0694d77852d3b4620378e451f9dddbb8fca52095932d7443b315800796b079f2"
    sha256 cellar: :any_skip_relocation, monterey:       "0694d77852d3b4620378e451f9dddbb8fca52095932d7443b315800796b079f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0694d77852d3b4620378e451f9dddbb8fca52095932d7443b315800796b079f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f73e0cf54bd9fa95c3d8fa5c9c113c4e80a237baf2ee10803dc75d870840dc85"
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
