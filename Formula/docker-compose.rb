class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.10.2.tar.gz"
  sha256 "74c86d544fcfb80bb2d3b58187bd017adb0e62863d22114a66c14fc94fdbc421"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99d746a2e370718b6a6947bdcdcf275aae79f1866c70d7410e1b5a5f673f507b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99d746a2e370718b6a6947bdcdcf275aae79f1866c70d7410e1b5a5f673f507b"
    sha256 cellar: :any_skip_relocation, monterey:       "e7f01edca79e860b97bfce9597ee2ce520da84c20c0e083a81d4b525cfb0af22"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7f01edca79e860b97bfce9597ee2ce520da84c20c0e083a81d4b525cfb0af22"
    sha256 cellar: :any_skip_relocation, catalina:       "e7f01edca79e860b97bfce9597ee2ce520da84c20c0e083a81d4b525cfb0af22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0158d66ca49f4568c7e55949323ae9030656377411cec22e2602ee83cd3f067e"
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
