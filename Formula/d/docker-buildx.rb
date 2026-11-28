class DockerBuildx < Formula
  desc "Docker CLI plugin for extended build capabilities with BuildKit"
  homepage "https://docs.docker.com/buildx/working-with-buildx/"
  url "https://github.com/docker/buildx/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "ccb549da4ec19317a04e68c9a3603553503743b8deee0e0613e0cb06c87ed6bc"
  license "Apache-2.0"
  head "https://github.com/docker/buildx.git", branch: "master"

  bottle do
    manifest_sha256 "af1c5dd52dddb719ed8cb31503565b70679e5e95add3cec2f46a92d4cf8c16c1"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bd90636bf0b17fd072f0aee114ebc8bde6e8ef76ea1b8b7bc6859117ed97a207"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd90636bf0b17fd072f0aee114ebc8bde6e8ef76ea1b8b7bc6859117ed97a207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd90636bf0b17fd072f0aee114ebc8bde6e8ef76ea1b8b7bc6859117ed97a207"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfee57450ba56e155212a38f94052c11f79908ee98d90b3bbf58978a946c9431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3e14c71bc5a57448022287b238f908b3d7c494a047a342d9bb2b937fe2e12205"
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
