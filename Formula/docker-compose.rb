class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.13.0.tar.gz"
  sha256 "b24ca9b04ad511412af6595a7c3d6a3c119c920b7429545b4e6f70be07523007"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70dcd6ae101a5707da71e3d4c7d26d7987fd669094b86bdea2ac1174768a9592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70dcd6ae101a5707da71e3d4c7d26d7987fd669094b86bdea2ac1174768a9592"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70dcd6ae101a5707da71e3d4c7d26d7987fd669094b86bdea2ac1174768a9592"
    sha256 cellar: :any_skip_relocation, monterey:       "473fd5caff0f0565443ffeb06723ec70b84fdca50938f09c176b2e939b3ee6af"
    sha256 cellar: :any_skip_relocation, big_sur:        "473fd5caff0f0565443ffeb06723ec70b84fdca50938f09c176b2e939b3ee6af"
    sha256 cellar: :any_skip_relocation, catalina:       "473fd5caff0f0565443ffeb06723ec70b84fdca50938f09c176b2e939b3ee6af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f608c03b8b39610e2f02db28136f275df96f03a66d342c9329bb5809addbb384"
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
