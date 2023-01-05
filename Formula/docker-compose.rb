class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.15.0.tar.gz"
  sha256 "da1e2b9760596dad690d5c6bc1a1c3868c67994836c2bb7e3ffbe9c811a9c580"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2418ab524836b20a73ddbced80971c5405283c4f85dbab1f6f13d33fd795f8a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2418ab524836b20a73ddbced80971c5405283c4f85dbab1f6f13d33fd795f8a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2418ab524836b20a73ddbced80971c5405283c4f85dbab1f6f13d33fd795f8a6"
    sha256 cellar: :any_skip_relocation, ventura:        "16eb94550293c09791b52aeb36dac7ab48caffa74725a84225e8d6ec8e6b36c3"
    sha256 cellar: :any_skip_relocation, monterey:       "16eb94550293c09791b52aeb36dac7ab48caffa74725a84225e8d6ec8e6b36c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "16eb94550293c09791b52aeb36dac7ab48caffa74725a84225e8d6ec8e6b36c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a702b403e8ea0c49795224eb85cf7f75db5931bdec53aacacabf2de3d737f809"
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
