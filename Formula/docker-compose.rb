class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.17.0.tar.gz"
  sha256 "672c875af691b2a4d7d231caf0d2602d839effefe8e7166a0ebfc333ad99c23b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccf0618e16228172792903be297f51a6db9d72e7b0a61cc055cf9ccc19cdd3b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fb406ad9829e3971564a9a7322a717221bbd0e9d9424066d4f3bfa61b4c2308"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f986022ad2314dc87e805b90cb9963bcd3ccd2a187e7f8feee5e7cf7a1ad222"
    sha256 cellar: :any_skip_relocation, ventura:        "769bedbe0d94a459fcbba22cbf955538acb72faa3973995553d4c06d9554a1f7"
    sha256 cellar: :any_skip_relocation, monterey:       "432c69ace84093350a8dee7a193b62cde7472b8a61d18a688d6a741f67cefa89"
    sha256 cellar: :any_skip_relocation, big_sur:        "59da00513d74ae4b6f6b93b2d49db8565ea3c3b8906678154b695a71c5b3bcf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d8a0886a7a289b49f994379b7dcbfcf826392ad3d87a065a0bc7626892cb3a3"
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
