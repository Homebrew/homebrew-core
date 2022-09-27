class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.11.2.tar.gz"
  sha256 "592e712f568938046602c0d4c225bc3c333e2b77574634fa0f39a8c066d04561"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6080f6db8bccf737a00e27ac10abf0c12f3f37efe3d74a6df533771e205b927c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6080f6db8bccf737a00e27ac10abf0c12f3f37efe3d74a6df533771e205b927c"
    sha256 cellar: :any_skip_relocation, monterey:       "6bae22155e879c23aa913d889942ce9ae2869151ee6257e04428e0710105d733"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bae22155e879c23aa913d889942ce9ae2869151ee6257e04428e0710105d733"
    sha256 cellar: :any_skip_relocation, catalina:       "6bae22155e879c23aa913d889942ce9ae2869151ee6257e04428e0710105d733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a57307f97c7e4401360ed10d31c23cae44a429886fdb67c837c3f38126897a3"
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
