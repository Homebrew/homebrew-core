class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/refs/tags/v2.20.3.tar.gz"
  sha256 "af8025623de3991a15a89575ae4fc4f3f38a17311af9641815500c01f0775950"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be205e463441886a5aca153d209d10d75ee5030d160880f6c2bcf59362cdadc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f7ad1d9819ed0e13bf7154faa1a82ac5d39d43d87a100c7c9fec75874c53d1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed5990e62496b639de7ccaf373609c2dad4cf99ca1aee8e17175edfcf9f211ae"
    sha256 cellar: :any_skip_relocation, ventura:        "a5871051166308cdd2a18e94dc5e559747695d2a7ab99fb941c63831e60128fb"
    sha256 cellar: :any_skip_relocation, monterey:       "174117b0c540c90033c0835e493f19bf96d5bc97a28dd12f0b2a19e179aa8638"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebb8717c72cbd00e9dd582318f3a6b0f273e46bab26705d621d0202e04771a68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d4d46dd48c230cf2e19b342c2a72bea0d819247282df65daade3737b2b03ebe"
  end

  depends_on "go" => :build

  def install
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
