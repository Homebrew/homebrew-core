class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.6.1.tar.gz"
  sha256 "7d4ad5354e382809368016210b33c4f6c3bca68da15e36edc671da00fb234666"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a40f5ea0ff2b64e13483b555e84e182535b8297b755fbbed0f12853a55e2180a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a40f5ea0ff2b64e13483b555e84e182535b8297b755fbbed0f12853a55e2180a"
    sha256 cellar: :any_skip_relocation, monterey:       "886de1e16c487da7cf62f0febf3adbea7a21f28aff542b6ec42b956f2d32eb55"
    sha256 cellar: :any_skip_relocation, big_sur:        "886de1e16c487da7cf62f0febf3adbea7a21f28aff542b6ec42b956f2d32eb55"
    sha256 cellar: :any_skip_relocation, catalina:       "886de1e16c487da7cf62f0febf3adbea7a21f28aff542b6ec42b956f2d32eb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e9a19556deef190d1c0bc62054ecbdf7f671126ef88af51d69399650510bb73"
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
