class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.15.1.tar.gz"
  sha256 "8ace5441826c6f07f5aa12c1864f73d30a362703492d9ed4b2e2314d3b353b1b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fbd0becc3d0f2505ba7b0f695d96aee6cbc2cf71d7f0534d9377a44d1f844ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fbd0becc3d0f2505ba7b0f695d96aee6cbc2cf71d7f0534d9377a44d1f844ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0fbd0becc3d0f2505ba7b0f695d96aee6cbc2cf71d7f0534d9377a44d1f844ef"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5228637dfd55142c0f2e88cce56b236e70700529d96207b966a47bc0237de9"
    sha256 cellar: :any_skip_relocation, monterey:       "aa5228637dfd55142c0f2e88cce56b236e70700529d96207b966a47bc0237de9"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa5228637dfd55142c0f2e88cce56b236e70700529d96207b966a47bc0237de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "379e6efb4a405306d00327d2cb9b02b063ca185981bbb70b235314206639b04d"
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
