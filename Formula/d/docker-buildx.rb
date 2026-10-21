class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "bfd908c66d13c88cb6dccbc6d0fbb68aab17446901ba24203b5019ebf9d32f67"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b7a1b0ac94fc9c90d0281e8092f5848fabcd56017b9ea21611574d3c06c13437"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b7a1b0ac94fc9c90d0281e8092f5848fabcd56017b9ea21611574d3c06c13437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7a1b0ac94fc9c90d0281e8092f5848fabcd56017b9ea21611574d3c06c13437"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ecfacbbda1cf30f5164a20c8ac32eaaf156ff111dff8b6c25469221eeafa55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a60611ef58b46249931ac53e34ce7ed4193da0db44c930067e073f8ac0cf6f87"
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
