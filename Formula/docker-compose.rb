class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.18.1.tar.gz"
  sha256 "192c47c177d9bfd8492ed0c49214af0c740586da6db0b7e9c9a07da37c9dc722"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897dc79f6c50932857dfffa5a235e40b5abb3255fdff40cf63f4f55d166e00a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a85ade54556b4853750b97ab4166e3f171328b96e8935fca950cce1b420abe60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60ac8ab0b164b7421e43cbfb3786ff3a7134bafdfdef58c99f6a0a3c6504fa7f"
    sha256 cellar: :any_skip_relocation, ventura:        "89023c969a1ae89fadd9ad5989b0b8c7e83aabf89450eaef5415692ec635ae25"
    sha256 cellar: :any_skip_relocation, monterey:       "e1c70543e30fba86883c94467b2c0d23292ca6a974c86a3194f5b63299c339fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f05868235ae5ab7bed20a821192b200beebd586c74905f4c46c0f0e7242efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b549885ed12fb1af9396a59755cd3255256e84d4c02c2d86eaf711113a432c77"
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
