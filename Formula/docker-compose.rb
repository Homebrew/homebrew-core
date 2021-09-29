class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.0.1.tar.gz"
  sha256 "5a1b1fdb9681c6f4b39fceab7d7dca12285e72cb55e3d35c31f4659cc939cd2b"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "67d4e74c8293c978dd8e4133fedbd138d388de7f073768bf427d42a62f98e384"
    sha256 cellar: :any,                 big_sur:       "60d80060410d0556a0bd72a9f632d79fb54e6a63c99aa9c84bb952a558b7f0e2"
    sha256 cellar: :any,                 catalina:      "1b493a40b98311fa83c833cc935bbc6a9e0e3d60a251b6559fdddd9e071b9d30"
    sha256 cellar: :any,                 mojave:        "8db2876a849e55de80f69c34f7c13fbf5fd5f7e547406738f46841db5fb3691a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "307d940f475b9f12d5c2eaab8a6dee986fbcf6b44bd74cac4a6ca12acaf4bce2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/compose/v2/internal.Version=#{version}
    ].join(" ")
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
    assert_match "can't find a suitable configuration file", output
  end
end
