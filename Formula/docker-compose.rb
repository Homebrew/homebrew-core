class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.5.0.tar.gz"
  sha256 "e002f4f50bfb1b3c937dc0a86a8a59395182fe1288e4ed3429db5771f68f7320"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5162554bb66b87a19adfaa75e28f55ad82abc65c433d5331fb67601a5c168bf5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5162554bb66b87a19adfaa75e28f55ad82abc65c433d5331fb67601a5c168bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "172c802647a2ee7c63402cdf25a0c002f68c73db91c1ce61a51e3fdae91e2ba8"
    sha256 cellar: :any_skip_relocation, big_sur:        "172c802647a2ee7c63402cdf25a0c002f68c73db91c1ce61a51e3fdae91e2ba8"
    sha256 cellar: :any_skip_relocation, catalina:       "172c802647a2ee7c63402cdf25a0c002f68c73db91c1ce61a51e3fdae91e2ba8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5ddf6cf3b89be0ec4e722a11d7a95ab119f247213cb116c56a1e055e51a8f40"
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
