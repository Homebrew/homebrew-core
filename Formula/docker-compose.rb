class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.19.0.tar.gz"
  sha256 "0be3fd713ef84985f63d76de4c58451401aed1dfbeb235127dd77a57d1890996"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78bdca9ed17f8b47f037f6975aec5d7e817a5c9cc257d2482d44a3a7e80ee8cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b192c7861fbb920528087d67195cfa81eb9dcbd38a35334bcb29937a74ec215"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77a2cb238e7f70a1ac2ccf4326a2ea00e66115346c3e895d7f5bd3a1fa2524e3"
    sha256 cellar: :any_skip_relocation, ventura:        "027ae3b96b68a9915590bda44b6798a0cac6fa4a7a712f76cb23c55c65302f9c"
    sha256 cellar: :any_skip_relocation, monterey:       "5f2d1e56a8fc730db31b59d2dd872be6d815b72824142ffc422947ffa8030938"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2d0d3f7444a5632f8049ecf89bd60c8eea406564b248aee616fded4b140e206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "428086ef204a5bcdf86687c4a74284db9be34c4bd0e421af841d1946845673a6"
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
