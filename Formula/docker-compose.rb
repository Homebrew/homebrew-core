class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.3.2.tar.gz"
  sha256 "11c1ea791698ec04c56d69207cf7b256e11b8dd2b4ae7b21cb5cdf875f5fe00a"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a8c82e1ae4c8038aba0126d256f6da07b90c0da9f3815d13fbc00304856b4ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a8c82e1ae4c8038aba0126d256f6da07b90c0da9f3815d13fbc00304856b4ed"
    sha256 cellar: :any_skip_relocation, monterey:       "017c93057367124ab04c6f8e4e46fe6f07bc78e79e5eb055712f5437d0b8ab08"
    sha256 cellar: :any_skip_relocation, big_sur:        "017c93057367124ab04c6f8e4e46fe6f07bc78e79e5eb055712f5437d0b8ab08"
    sha256 cellar: :any_skip_relocation, catalina:       "017c93057367124ab04c6f8e4e46fe6f07bc78e79e5eb055712f5437d0b8ab08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2150fd944d50e896420467e749b396acd76a591bc48f0eae240817b9ff2bab8c"
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
