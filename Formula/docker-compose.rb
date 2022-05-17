class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.5.1.tar.gz"
  sha256 "f3eeaac99d2467fe482f499787ae38f66738bc0641dbf34a6045f34aaab893b7"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27be64fc83b866371dcc7a32a2d8d5c77c84089b58093a5fd63df7db895b0763"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27be64fc83b866371dcc7a32a2d8d5c77c84089b58093a5fd63df7db895b0763"
    sha256 cellar: :any_skip_relocation, monterey:       "425533b019228473b5e29421ad77c383f504513ad87c3c48beed9bf951f45388"
    sha256 cellar: :any_skip_relocation, big_sur:        "425533b019228473b5e29421ad77c383f504513ad87c3c48beed9bf951f45388"
    sha256 cellar: :any_skip_relocation, catalina:       "425533b019228473b5e29421ad77c383f504513ad87c3c48beed9bf951f45388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f8ebd761ac998ad553b31167242930a86ac5811fd968d02b1b6faecc1c6def6"
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
