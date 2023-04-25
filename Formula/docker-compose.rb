class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v2.17.3.tar.gz"
  sha256 "e5e9bdfc3a827240381b656da88f92b408ea2e203c3f8cfd9e0bbfe03f825f16"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d923dedc5c1b6d87a62d9e3c1d0c6389953a4a8d474facc4de8ad6802f1d44c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6334f98055ddb490c1fc7d7094975710c71918750806591fb1b64ac39679361f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d2a6e749813abcd5c7e525318a0f96bce3a92e47588540c27156760037272b4"
    sha256 cellar: :any_skip_relocation, ventura:        "18c62f738d77dfa2098e4548276a4f00f3cd9148c897be764b908de9e315623d"
    sha256 cellar: :any_skip_relocation, monterey:       "e09f309ae8c7f6edba9b60425796426fdcaf3d8fc3001805d3a1348a5264a3d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "38474c26f35420fcac0b103d3a3b8bc9f6e4ba11eb8c4bd38039d8fe3dab66f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08ca12fb0a754dd51f1bbd6455948edd9bdc08c690a960e58e330b3e5c0d1cbd"
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
