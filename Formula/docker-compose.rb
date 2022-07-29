class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.8.0.tar.gz"
  sha256 "fa3e7242c0f3a2158e6ccc20b05dd5a5124cfe8ed96a76b16bb32145f410728d"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "240d89351ba2606c6601adb0107c31d334c4d0bacb3f66d4bc1175ba4151237f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "240d89351ba2606c6601adb0107c31d334c4d0bacb3f66d4bc1175ba4151237f"
    sha256 cellar: :any_skip_relocation, monterey:       "35420139da3e16fa506424dc85904f1d74bc505bce16b8071dd09e570f9d4e15"
    sha256 cellar: :any_skip_relocation, big_sur:        "35420139da3e16fa506424dc85904f1d74bc505bce16b8071dd09e570f9d4e15"
    sha256 cellar: :any_skip_relocation, catalina:       "35420139da3e16fa506424dc85904f1d74bc505bce16b8071dd09e570f9d4e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "200527462b65098b9d315094e5a0de424914818eadc8b2ac7b2e38fa1132f0d5"
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
