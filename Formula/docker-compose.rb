class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.10.0.tar.gz"
  sha256 "981282ee5cc454a69f1d56845efea5645ff90295b9198decfc62674a9e286baa"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f3720b46ca99ec2e486fea02bf776d8209f884e5d8d562140e0d81f1f713fd4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f3720b46ca99ec2e486fea02bf776d8209f884e5d8d562140e0d81f1f713fd4"
    sha256 cellar: :any_skip_relocation, monterey:       "049251a8603fe0e449cd66645739c4f2ff8cc9704bbf214174038e99f8fc335c"
    sha256 cellar: :any_skip_relocation, big_sur:        "049251a8603fe0e449cd66645739c4f2ff8cc9704bbf214174038e99f8fc335c"
    sha256 cellar: :any_skip_relocation, catalina:       "049251a8603fe0e449cd66645739c4f2ff8cc9704bbf214174038e99f8fc335c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6350f1625f1c6423d60ec60470dbe8bc8c283157c7860b18123306d061d4b00b"
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
