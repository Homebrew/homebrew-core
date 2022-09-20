class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.11.1.tar.gz"
  sha256 "16c5fa92bdabc1f39526e40319c0975e37246bc87a873c92bf960fece47e2c3e"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93fc105cb4f80e013f0e31d367d121692a90b83d1d9ca8a00a657d434b2b65e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93fc105cb4f80e013f0e31d367d121692a90b83d1d9ca8a00a657d434b2b65e6"
    sha256 cellar: :any_skip_relocation, monterey:       "9d5a191d3f938bdeb90f7e3cc459beb5bbd8d5f19abdd747a93318f2a856279f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d5a191d3f938bdeb90f7e3cc459beb5bbd8d5f19abdd747a93318f2a856279f"
    sha256 cellar: :any_skip_relocation, catalina:       "9d5a191d3f938bdeb90f7e3cc459beb5bbd8d5f19abdd747a93318f2a856279f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eaa69b2d5782997a783aa95acac3dec2f00da673da8012c45600ef89987db7c"
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
