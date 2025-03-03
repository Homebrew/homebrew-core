class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "fbb27467c5f532a2919706c4c76912f10aa19b04c5a87420a8fea6be3a870f18"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51b80763d4bcb599ad4f77eea43de2889d4edf8a8ca6ee5b6afa475e680b6fbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c9c899d813778e5789de7557b8dfca9c6f6e36f2721e4ea14669bcd5f6744c"
    sha256 cellar: :any_skip_relocation, ventura:       "06c9c899d813778e5789de7557b8dfca9c6f6e36f2721e4ea14669bcd5f6744c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08272d3f34d7a1c70b40fb29e2772101c3ea1ab277f41f3f04e9bd6c15ee1c58"
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
