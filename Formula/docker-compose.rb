class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.4.1.tar.gz"
  sha256 "ebf56ab2f3912d49f4ef9a0e48b219cf9cbff958d20990a5ff9b7a8ced8e69fc"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e87ec830ea1ffc6756ed0b692f4826f7c68a5569d704ce8f2cc2e7d77a3a24f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e87ec830ea1ffc6756ed0b692f4826f7c68a5569d704ce8f2cc2e7d77a3a24f6"
    sha256 cellar: :any_skip_relocation, monterey:       "d59c73e600795f9bc390525fa9fa959d1b853ba73d4d5b3e1afcc1c0525f7bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d59c73e600795f9bc390525fa9fa959d1b853ba73d4d5b3e1afcc1c0525f7bcb"
    sha256 cellar: :any_skip_relocation, catalina:       "d59c73e600795f9bc390525fa9fa959d1b853ba73d4d5b3e1afcc1c0525f7bcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ddb468273a6c7f2fe662f0997565d0e098f85ad88304e5a62f5082e802597e"
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
