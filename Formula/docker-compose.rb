class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.3.4.tar.gz"
  sha256 "10657bbca710b7bfe7e17f259a4ab6cf69b890e7ac4b3bfc2444ef3086bd89cb"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3f4dbcbdcf73448ce879aafdd4ffd2e261b5eda2ce5efbf0336ee525a0ea06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae3f4dbcbdcf73448ce879aafdd4ffd2e261b5eda2ce5efbf0336ee525a0ea06"
    sha256 cellar: :any_skip_relocation, monterey:       "c92fabf5fd337d1dba7ef849aaf1c0ca0fda7d80161964edaffdeb913eea846c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c92fabf5fd337d1dba7ef849aaf1c0ca0fda7d80161964edaffdeb913eea846c"
    sha256 cellar: :any_skip_relocation, catalina:       "c92fabf5fd337d1dba7ef849aaf1c0ca0fda7d80161964edaffdeb913eea846c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a5ede95cdf452a90b44dfa58e78436debcb16778e04d565d694bf091289e14e"
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
