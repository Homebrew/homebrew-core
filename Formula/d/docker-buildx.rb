class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "1d20ca3cec6438b008eb6e0805c4842d4e27447690b4150df607790ca75629c0"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1463ddd442ac37c69582053f0ff67a5ab0153c182d4dd93f16255eea4eb1e57a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1463ddd442ac37c69582053f0ff67a5ab0153c182d4dd93f16255eea4eb1e57a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1463ddd442ac37c69582053f0ff67a5ab0153c182d4dd93f16255eea4eb1e57a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a40cfe885fc9e640e9f33a604c99680d4aee7d10bfc28a28fd51795b7b2d333a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d140e9efce558a835a193f9f0c6a77774591e5df3a8cfcc4a62661d7dfaa0133"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -X github.com/docker/buildx/version.Version=v#{version}
      -X github.com/docker/buildx/version.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/buildx"

    (lib/"docker/cli-plugins").install_symlink bin/"docker-buildx"
    doc.install buildpath.glob("docs/reference/*.md")

    generate_completions_from_executable(bin/"docker-buildx", shell_parameter_format: :cobra)
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
    assert_match(/(denied while trying|failed) to connect to the docker API/, output)
  end
end
