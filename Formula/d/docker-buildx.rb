class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "f20556fec0a4e859e57ac8343851ad91054b90fa12855b1fbc6c277a01a85a7a"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3053c872d1699c5972d66d1d35f53710090d6f10d684c6fcd596027bdccd74c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "425914fbd1bf45db0d6cc4d66f16d5b2535b85e5a0f5e50d0b6d3d830b713431"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "425914fbd1bf45db0d6cc4d66f16d5b2535b85e5a0f5e50d0b6d3d830b713431"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "425914fbd1bf45db0d6cc4d66f16d5b2535b85e5a0f5e50d0b6d3d830b713431"
    sha256 cellar: :any_skip_relocation, sonoma:        "506a4f11c600f92ce236fdce5c3f51aea5948665783cfe6de81d50acf9b6c293"
    sha256 cellar: :any_skip_relocation, ventura:       "506a4f11c600f92ce236fdce5c3f51aea5948665783cfe6de81d50acf9b6c293"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738a0ee9cd5d56e4be186a243f0cd2f01098c24fb7f872e49559696fb6732361"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f100782bb475d046eaba84062375c380ffa1524121fb01f998ee0d9088f6b3db"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

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
    output = shell_output("#{bin}/docker-buildx build . 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
