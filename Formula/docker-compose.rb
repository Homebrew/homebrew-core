class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.12.2.tar.gz"
  sha256 "311131c5d930fdb1f5e86de19ea2ad1705d23e5745b780c0b10b2eb3f964fc69"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "964790e945e5398338d24a7cf616daa4bae044d96b7a53b6eab560437d188b1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "964790e945e5398338d24a7cf616daa4bae044d96b7a53b6eab560437d188b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "4eb1f1e699b7508ce5ff0a111abb2d60e655dc58b840a21764dfd4a47c97fec9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4eb1f1e699b7508ce5ff0a111abb2d60e655dc58b840a21764dfd4a47c97fec9"
    sha256 cellar: :any_skip_relocation, catalina:       "4eb1f1e699b7508ce5ff0a111abb2d60e655dc58b840a21764dfd4a47c97fec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5627b36e71caa81ae0c20757d9c23928da6a2c6ca3d933c4cae42fb299f5235b"
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
