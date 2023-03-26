class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.17.2.tar.gz"
  sha256 "d6e6de858ecdb0104991c86c66dde5dd4fb6a1160d707308d8ad3167450c8094"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b42978af725a8a72360e7c143350726368c7cd9620a4655cff20bdc7fcace5f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c877a5e65610e503a0adee74d5a7bd936f329be8bea4f9fe9f80cadf7bc6009"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b7ddecdd4e6949fff447895fbb3ef03f10b3f8ed0b415cf8c0619443911f56"
    sha256 cellar: :any_skip_relocation, ventura:        "2df0ad0e16223cf0d70ca02d54397b1ad81c26f1bd7b273aceedde725f0b505d"
    sha256 cellar: :any_skip_relocation, monterey:       "de8ba87a7f370040946a29819b105a4ab896f31bab56102693a3ea5a0d9b9f4a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a141fcd9cfe0dce201a018444aa71efd2b84bd7a65ec70df8c33bd0fe2ef7395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e01649445c0cdfa1f53f08721d4c6d300fc58f42bbccfcc2e58cc18d9e63b8c1"
  end

  depends_on "go" => :build

  def install
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
