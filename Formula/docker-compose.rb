class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.14.1.tar.gz"
  sha256 "4e3e92169ad9142718a168b71dc5027f173be4cdb6563f42c60677818efd7509"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "683b3b4268d75568b39a147b8f38d1a807359f99575bde976b6edb343161fad5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "683b3b4268d75568b39a147b8f38d1a807359f99575bde976b6edb343161fad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "683b3b4268d75568b39a147b8f38d1a807359f99575bde976b6edb343161fad5"
    sha256 cellar: :any_skip_relocation, ventura:        "65142b65e75df1f77d39f35a736f14c846d84e3e650091a867c62b66b2b51fc2"
    sha256 cellar: :any_skip_relocation, monterey:       "65142b65e75df1f77d39f35a736f14c846d84e3e650091a867c62b66b2b51fc2"
    sha256 cellar: :any_skip_relocation, big_sur:        "65142b65e75df1f77d39f35a736f14c846d84e3e650091a867c62b66b2b51fc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc86a5e12bb10a0da9f4d30fa707d6b4f56fcf54c677c0b821ac22e2dfba37ef"
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
