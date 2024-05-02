class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "9ed27d47b728288500ba2535366792d9b006354e02178688360919663f92b63e"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc4f578cb72ac9316dc8a4bfb169c04cc07a41a34029a14dcbbdbdd588f5b023"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f45d15f0f5ebd9c6842b5274f9538836290f8325f61ee2e3847c50b0ef3f7a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc0e6f21cc744b773abed00732a83a017720895177b6d5ef60043a92dde260aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "efbbd5d38ccc3fd2b17cd3ff2ee5908495bbabed5daaa5133ea048d3b3312e70"
    sha256 cellar: :any_skip_relocation, ventura:        "3b4538a21f886cda0cfea32212d8eed92ed2ca439da1f3929b3aa19fd2ddeb8b"
    sha256 cellar: :any_skip_relocation, monterey:       "d592a49e2479a13056f5562cb5d0aa0f0419b564289d36cd11db1c447973105e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc248ed7d4276f454767ca3f328b5fd82f372e4e05866cfd73022a72ed0ca11"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"

    doc.install Dir["docs/reference/*.md"]

    generate_completions_from_executable(bin/"docker-buildx", "completion")
  end

  def caveats
    <<~EOS
      docker-buildx is a Docker plugin. For Docker to find the plugin, add "cliPluginsExtraDirs" to ~/.docker/config.json:
        "cliPluginsExtraDirs": [
            "#{HOMEBREW_PREFIX}/lib/docker/cli-plugins"
        ]
    EOS
  end

  test do
    assert_match "github.com/docker/buildx v#{version}", shell_output("#{bin}/docker-buildx version")
    output = shell_output(bin/"docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
