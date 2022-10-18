class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.12.0.tar.gz"
  sha256 "f0633461be71a920a511ab3f1c013913eb2a1650debecc1ab8d101eb536684a1"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e51c1cac72e3d7b1a6a6c9390bb352b7e579a92f63e2a972e90c2c4482156208"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e51c1cac72e3d7b1a6a6c9390bb352b7e579a92f63e2a972e90c2c4482156208"
    sha256 cellar: :any_skip_relocation, monterey:       "82bb6e895e1d0fd67289fd07352bc1690d6cd74ca234f57937648b3333eabdef"
    sha256 cellar: :any_skip_relocation, big_sur:        "82bb6e895e1d0fd67289fd07352bc1690d6cd74ca234f57937648b3333eabdef"
    sha256 cellar: :any_skip_relocation, catalina:       "82bb6e895e1d0fd67289fd07352bc1690d6cd74ca234f57937648b3333eabdef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b17fac2038da3281905c20bb3138fbf2cfe37430726bd8d9a76a6e56bb684b"
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
