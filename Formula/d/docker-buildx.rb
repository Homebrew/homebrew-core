class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "f314635765f3dc5efe089244280cd24a577e83d339fec1970fed16977bf28382"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56a03513c2d6ff1160f6bd71fda2988640017640d9f065839478150dc2e610ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "654143a8adb5e856f1b26d5da74d8f97a166106cec92ab20f9ee9100d717c338"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea586abe24487bf5a3798ee1650cbedea1737c7ea406f0fe762e3e0a0d9f660d"
    sha256 cellar: :any_skip_relocation, sonoma:         "6392a90372fe8f4c66419f7adaffdd7ee67b8b1887f8d38fde8a3ff1b4fa39a6"
    sha256 cellar: :any_skip_relocation, ventura:        "9f25ea1ded3adc1685016ef4a453f7ea97c815702f5942c1d7aeb1ac1d724ce5"
    sha256 cellar: :any_skip_relocation, monterey:       "5dcf6b7b5fa75dfeb5273f603c3e1e98772fa2598542f2c32a0c5b6931cbf580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa77690b7745955fa8e4d41f16805b6f0179f18abe90cd55c0cc22ec73ca9e55"
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
