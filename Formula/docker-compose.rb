class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.6.1.tar.gz"
  sha256 "7d4ad5354e382809368016210b33c4f6c3bca68da15e36edc671da00fb234666"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e052ab367d89418271adea2f79fba6787c3e8529ad39e015206e48cafa88bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e052ab367d89418271adea2f79fba6787c3e8529ad39e015206e48cafa88bda"
    sha256 cellar: :any_skip_relocation, monterey:       "9c319d5de5b569102ce52b2327b009c2b2659677a98144f2e48c80f098f95650"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c319d5de5b569102ce52b2327b009c2b2659677a98144f2e48c80f098f95650"
    sha256 cellar: :any_skip_relocation, catalina:       "9c319d5de5b569102ce52b2327b009c2b2659677a98144f2e48c80f098f95650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee3bf79a19a909a6844a4827b77520fa08039a77f4240876d8b9676633c214b"
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
